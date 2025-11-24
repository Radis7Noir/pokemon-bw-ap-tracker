ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/utils.lua")
ScriptHost:LoadScript("scripts/autotracking/encounter_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/flag_mapping.lua")

-- used for hint tracking to quickly map hint status to a value from the Highlight enum
HINT_STATUS_MAPPING = {}
if Highlight then
    HINT_STATUS_MAPPING = {
        [20] = Highlight.Avoid,
        [40] = Highlight.None,
        [10] = Highlight.NoPriority,
        [0] = Highlight.Unspecified,
        [30] = Highlight.Priority,
    }
end

CUR_INDEX = -1
PLAYER_ID = -1
TEAM_NUMBER = 0
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}

function onClear(slot_data)
    print(string.format("called onClear, slot_data:\n%s", dump_table(slot_data)))
    SLOT_DATA = slot_data
    CUR_INDEX = -1
    LOCAL_ITEMS = {}
    GLOBAL_ITEMS = {}
    CAUGHT = {}
    SEEN = {}
    PLAYER_ID = Archipelago.PlayerNumber or -1
    TEAM_NUMBER = Archipelago.TeamNumber or 0

    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] and v[2] then
            for _, code in ipairs(v[1]) do
                resetItem(code, v[2])
            end
        end
    end

    -- reset dexsanity items
    for i = 1, 649 do
        Tracker:FindObjectForCode("dexsanity_visibility_" .. i).Active = false
        Tracker:FindObjectForCode("dexsanity_sent_" .. i).Active = false
        Tracker:FindObjectForCode("caught_" .. i).Active = false
    end

    -- so we can access the mapping later
    POKEMON_TO_LOCATIONS = {}
    for location, dex_list in pairs(slot_data["encounter_by_method"]) do
        for _, dex_number in pairs(dex_list) do
            if POKEMON_TO_LOCATIONS[dex_number] == nil then
                POKEMON_TO_LOCATIONS[dex_number] = {}
            end
            table.insert(POKEMON_TO_LOCATIONS[dex_number], location)
        end
    end
    
    -- This sets each Encounter location to however many unique encounters there are in it
    for region_key, location in pairs(ENCOUNTER_MAPPING) do
        local object = Tracker:FindObjectForCode(location)
        object.AvailableChestCount = #slot_data.encounter_by_method[region_key]
    end
    
    REGION_ENCOUNTERS = slot_data.encounter_by_method

    -- Main Slot Data Processing
    for k, v in pairs(slot_data.options) do
        if k == "season_control" then
            local item = Tracker:FindObjectForCode("season_control")
            if v == "vanilla" then
                item.CurrentStage = 0
            elseif v == "changeable" then
                item.CurrentStage = 1
            elseif v == "randomized" then
                item.CurrentStage = 2
            end
        elseif k == "goal" then
            local item = Tracker:FindObjectForCode("goal")
            local mapping = {
                ghetsis = 0,
                champion = 1,
                cynthia = 2,
                cobalion = 3,
                tmhm_hunt = 4,
                seven_sages_hunt = 5,
                legendary_hunt = 6,
                pokemon_master = 7
            }
            if mapping[v] ~= nil then
                item.CurrentStage = mapping[v]
            end
        elseif k == "shuffle_badges" then
            local item = Tracker:FindObjectForCode("shuffle_badges")
            if v == "vanilla" then
                item.CurrentStage = 0
            elseif v == "shuffle" then
                item.CurrentStage = 1
            elseif v == "any_badge" then
                item.CurrentStage = 2
            elseif v == "anything" then
                item.CurrentStage = 3
            end
        elseif k == "modify_logic" then
            local require_flash = Tracker:FindObjectForCode("require_flash")
            local require_dowsingmchn = Tracker:FindObjectForCode("require_dowsingmchn")
			local keyitem_priority = Tracker:FindObjectForCode("keyitem_priority")
            if table_contains(v, "require flash") then
                require_flash.CurrentStage = 1
            else
                require_flash.CurrentStage = 0
            end
            
            if table_contains(v, "require dowsing machine") then
                require_dowsingmchn.CurrentStage = 1
            else
                require_dowsingmchn.CurrentStage = 0
            end
			
			if table_contains(v, "prioritize key item locations") then
                keyitem_priority.CurrentStage = 1
            else
                keyitem_priority.CurrentStage = 0
            end
        elseif k == "adjust_levels" then
            local adjustlevels = Tracker:FindObjectForCode("adjustlevels")
            if table_contains(v, "wild") and table_contains(v, "trainer") then
                adjustlevels.CurrentStage = 1
		    elseif table_contains(v, "wild") then
                adjustlevels.CurrentStage = 2
			elseif table_contains(v, "trainer") then
                adjustlevels.CurrentStage = 3
            else
                adjustlevels.CurrentStage = 0
            end
        elseif k == "version" then
            local game_version = Tracker:FindObjectForCode("game_version")
            if v == "white" then
                game_version.CurrentStage = 1
            else
                game_version.CurrentStage = 0
            end
        elseif k == "dexsanity" then
            Tracker:FindObjectForCode("dexsanity").AcquiredCount = v
        end
    end
    
    for k, v in pairs(slot_data) do
        if k == "dexsanity_pokemon" then
            for _, pokeID in ipairs(v) do
                Tracker:FindObjectForCode("dexsanity_visibility_" .. pokeID).Active = true
            end
        end
    end
    
    -- Datastorage Watches
    if PLAYER_ID>-1 then
        updateEvents(0)
        
        EVENT_ID = "pokemon_bw_events_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({EVENT_ID})
        Archipelago:Get({EVENT_ID})

        POKE_CAUGHT_ID="pokemon_bw_caught_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({POKE_CAUGHT_ID})
        Archipelago:Get({POKE_CAUGHT_ID})
        
        POKE_SEEN_ID="pokemon_bw_seen_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({POKE_SEEN_ID})
        Archipelago:Get({POKE_SEEN_ID})
    end
    
    updatePokemon()
end

function resetItem(code, type)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onClear: clearing item %s of type %s", code, type))
    end
    local obj = Tracker:FindObjectForCode(code)
    if obj then
        if type == "toggle" then
            obj.Active = false
        elseif type == "progressive" then
            obj.CurrentStage = 0
            obj.Active = false
        elseif type == "consumable" then
            obj.AcquiredCount = 0
        elseif type == "flash_tm" then
            obj.AcquiredCount = 0
            Tracker:FindObjectForCode("tm70flash").Active = false
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onClear: unknown item type %s for code %s", v[2], code))
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onClear: could not find object for code %s", code))
    end
end

-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
    end
    if not AUTOTRACKER_ENABLE_ITEM_TRACKING then
        return
    end
    if index <= CUR_INDEX then
        return
    end
    CUR_INDEX = index;
    local v = ITEM_MAPPING[item_id]
    if not v then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: could not find item mapping for id %s", item_id))
        end
        return
    end
    if not v[1] then
        return
    end
    for _, code in ipairs(v[1]) do
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: code: %s, type %s", code, v[2]))
        end
        local obj = Tracker:FindObjectForCode(code)
        if obj then
            if v[2] == "toggle" then
                obj.Active = true
            elseif v[2] == "progressive" then
                if obj.Active then
                    obj.CurrentStage = obj.CurrentStage + 1
                else
                    obj.Active = true
                end
            elseif v[2] == "consumable" then
                obj.AcquiredCount = obj.AcquiredCount + obj.Increment
			elseif v[2] == "flash_tm" then
                obj.AcquiredCount = obj.AcquiredCount + obj.Increment
                Tracker:FindObjectForCode("tm70flash").Active = true
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onItem: unknown item type %s for code %s", v[2], code))
            end
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: could not find object for code %s", code))
        end
    end
end

-- called when a location gets cleared
function onLocation(location_id, location_name)
    local v = LOCATION_MAPPING[location_id]
    -- if not v then
    --     print(string.format("onLocation: could not find location mapping for id %s", location_id))
    -- end
    
    local obj = Tracker:FindObjectForCode(v)
    if obj then
    	if v:sub(1, 1) == "@" then
    		obj.AvailableChestCount = obj.AvailableChestCount - 1
    	elseif obj.Type == "progressive" then
    		obj.CurrentStage = obj.CurrentStage + 1
    	else
    		obj.Active = true
    	end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
    	print(string.format("onLocation: could not find object for code %s", v[1]))
    end
end

function onNotify(key, value, old_value)
    if value ~= nil and value ~= 0 then
        if key == EVENT_ID then
            updateEvents(value)
        elseif key == POKE_CAUGHT_ID then
            updateCaught(value)
        elseif key == POKE_SEEN_ID then
            updateSeen(value)
        end
    end
end

function onNotifyLaunch(key, value)
    if value ~= nil and value ~= 0 then
        if key == EVENT_ID then
            updateEvents(value)
        elseif key == POKE_CAUGHT_ID then
            updateCaught(value)
        elseif key == POKE_SEEN_ID then
            updateSeen(value)
        end
    end
end

function updateEvents(value)
    if value ~= nil then
        for i, code in ipairs(FLAG_EVENT_CODES) do
            local obj = Tracker:FindObjectForCode(code)
            if obj ~= nil then
                obj.Active = false
            end
            local bit = value >> (i - 1) & 1
            if #code > 0 then
                local obj = Tracker:FindObjectForCode(code)
                obj.Active = obj.Active or bit == 1
            end
        end
    end
end

function updateCaught(value)
    CAUGHT = value
    updatePokemon()
end

function updateSeen(value)
    SEEN = value
    updatePokemon()
end

function updatePokemon()

    for i = 1, 649 do
        if table_contains(CAUGHT, i) then
            Tracker:FindObjectForCode("caught_"..i).Active = true
        else
            Tracker:FindObjectForCode("caught_"..i).Active = false
        end
    end
    
    if has("encounter_tracking_off") then
        return
    end
    
    for region_key, location in pairs(ENCOUNTER_MAPPING) do
        local object = Tracker:FindObjectForCode(location)
        object.AvailableChestCount = #REGION_ENCOUNTERS[region_key]
    end
    
    for dex_number, locations in pairs(POKEMON_TO_LOCATIONS) do
        local dexVisibilityCode = Tracker:FindObjectForCode("dexsanity_visibility_" .. dex_number).Active
        local dexSentCode = Tracker:FindObjectForCode("dexsanity_sent_" .. dex_number).Active
        
        local is_caught = table_contains(CAUGHT, dex_number)
        local is_seen = table_contains(SEEN, dex_number)
        
        local should_decrement = false
        if is_caught then
            should_decrement = true
        elseif has("encounter_tracking_minimal") and (dexSentCode or not dexVisibilityCode) then
            should_decrement = true
        elseif has("encounter_tracking_seen") and not dexVisibilityCode and is_seen then
            should_decrement = true
        end
        
        if should_decrement then
            for _, location in pairs(locations) do
                local object_name = ENCOUNTER_MAPPING[location]
                if object_name ~= nil then
                    local object = Tracker:FindObjectForCode(object_name)
                    if object then
                        object.AvailableChestCount = object.AvailableChestCount - 1
                    end
                end
            end
        end
    end
end

-- add AP callbacks
Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddSetReplyHandler("notify handler", onNotify)
Archipelago:AddRetrievedHandler("notify launch handler", onNotifyLaunch)
