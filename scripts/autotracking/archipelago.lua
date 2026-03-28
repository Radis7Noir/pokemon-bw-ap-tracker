ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/utils.lua")
ScriptHost:LoadScript("scripts/autotracking/encounter_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/flag_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/map_mapping.lua")

REGION_ENCOUNTERS = {}
CUR_INDEX = -1
PLAYER_ID = -1
TEAM_NUMBER = 0
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}
HINT_ID = {}

if Highlight then
    HIGHLIGHT_LEVEL= {
        [0] = Highlight.Unspecified,
        [1] = Highlight.Priority,
        [2] = Highlight.NoPriority,
        [3] = Highlight.Priority,
        [4] = Highlight.Avoid,
        [5] = Highlight.Priority,
        [6] = Highlight.NoPriority
    }
end

HIGHLIGHT_PRIORITY =  {
    [3] = 1,
    [2] = 2,
    [-1] = 3,
    [1] = 4,
    [0] = 5
}

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
	
	resetLocations()

    -- reset dexsanity items
    for i = 1, 649 do
        Tracker:FindObjectForCode("dexsanity_sent_" .. i).Active = false
    end

    REGION_ENCOUNTERS = slot_data.encounter_by_method
    -- Static Encounters etc. added manually
    local newEncounters = {
	    Magikarp_Gift = 129,
		Zorua_Gift = 570,
		Larvesta_Egg = 636,
		Omanyte_Fossil = 138,
		Kabuto_Fossil = 140,
		Aerodactyl_Fossil = 142,
		Lileep_Fossil = 345,
		Anorith_Fossil = 347,
		Cranidos_Fossil = 408,
		Shieldon_Fossil = 410,
		Tirtouga_Fossil = 564,
		Archen_Fossil = 566,
		Munchlax_Trade = 446,
		Rotom_Trade = 479,
		Cottonee_Trade = 546,
		Petilil_Trade = 548,
		BasculinBlue_Trade = 550,
		BasculinRed_Trade = 550,
		Emolga_Trade = 587,
		Foongus_Trap6 = 590,
		Foongus_Trap10 = 590,
		Amoonguss_Trap = 591,
		Victini_Static = 494,
		Musharna_Static = 518,
		Darmanitan_Static = 555,
		Zoroark_Static = 571,
        Volcarona_Static = 637,
		Cobalion_Static = 638,
		Terrakion_Static = 639,
		Virizion_Static = 640,
		Reshiram_Static = 643,
		Zekrom_Static = 644,
		Landorus_Static = 645,
		Kyurem_Static = 646,
		Tornadus_Roamer = 641,
		Thundurus_Roamer = 642
		
    }
    
    for name, dexID in pairs(newEncounters) do
        REGION_ENCOUNTERS[name] = { dexID }
    end
    --print(dump_table(REGION_ENCOUNTERS))
    
    -- so we can access the mapping later
    POKEMON_TO_LOCATIONS = {}
    for location, dex_list in pairs(REGION_ENCOUNTERS) do
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
        object.AvailableChestCount = #REGION_ENCOUNTERS[region_key]
    end

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
            local consider_evolutions = Tracker:FindObjectForCode("consider_evolutions")
            local consider_statics = Tracker:FindObjectForCode("consider_statics")
            local consider_trades = Tracker:FindObjectForCode("consider_trades")

            require_flash.CurrentStage = table_contains(v, "require flash") and 1 or 0
            require_dowsingmchn.CurrentStage = table_contains(v, "require dowsing machine") and 1 or 0
            consider_evolutions.CurrentStage = table_contains(v, "consider evolutions") and 1 or 0
            consider_statics.CurrentStage = table_contains(v, "consider static pokemon") and 1 or 0
            consider_trades.CurrentStage = table_contains(v, "consider trades") and 1 or 0
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
        elseif k == "all_pokemon_seen" then
            Tracker:FindObjectForCode("all_pokemon_seen").Active = (v == 1)
        end
    end
    
    for k, v in pairs(slot_data) do
        if k == "dexsanity_pokemon" then
            local active = {}
    
            for _, pokeID in ipairs(v) do
                active[pokeID] = true
            end
    
            for i = 1, 649 do
                Tracker:FindObjectForCode("dexsanity_visibility_" .. i).Active = active[i] or false
            end
        end
    end

    -- Datastorage Watches
    if PLAYER_ID>-1 then
        updateEvents(0)

        local suffix = TEAM_NUMBER .. "_" .. PLAYER_ID
        local function makeID(s) return "pokemon_bw_" .. s .. suffix end

        IDs = {
            EVENT      = makeID("events_"),
            CAUGHT     = makeID("caught_"),
            SEEN       = makeID("seen_"),
            MAP      = makeID("map_"),
            HINT       = "_read_hints_" .. suffix,
        }
        for _, id in pairs(IDs) do
            Archipelago:SetNotify({id})
            Archipelago:Get({id})
        end
    end
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

function resetLocations()
    for id, value in pairs(LOCATION_MAPPING) do
        for _, code in pairs(value) do
            local object = Tracker:FindObjectForCode(code)
            if object then
                if code:sub(1, 1) == "@" then
                    object.AvailableChestCount = object.ChestCount
                    object.Highlight = 0
                else
                    object.CurrentStage = 0
                end
            end
        end
    end
end

---- we use this for hint tracking
CLEARED_LOCATIONS = {}

-- called when a location gets cleared
function onLocation(location_id, location_name)
    local value = LOCATION_MAPPING[location_id]
    if not value then
        return
    end
    for _, code in pairs(value) do
        local object = Tracker:FindObjectForCode(code)
        if object then
            if code:sub(1, 1) == "@" then
                object.AvailableChestCount = object.AvailableChestCount - 1
                local current_total = CLEARED_LOCATIONS[code] or 0
                CLEARED_LOCATIONS[code] = current_total + 1
            elseif object.Type == "progressive" then
                object.CurrentStage = object.CurrentStage + 1
            else
                object.Active = true
            end
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onLocation: could not find object for code %s", code))
        end
    end
end

function onNotify(key, value, old_value)
    if IDs == nil then
        return
    end

    if value ~= nil and value ~= 0 then
        if key == IDs.EVENT then
            updateEvents(value)
        elseif key == IDs.CAUGHT then
            CAUGHT = value
            updatePokemon()
        elseif key == IDs.SEEN then
            SEEN = value
            updatePokemon()
        elseif key == IDs.MAP then
            updateMap(value)
        elseif key == IDs.HINT then
            SAVED_HINTS = value
            updateHints()
            updatePokemon()
        end
    end
end

function updateEvents(value)
    if value ~= nil then
        for i, code in ipairs(FLAG_EVENT_CODES) do
            local bit = (value >> (i - 1)) & 1
            Tracker:FindObjectForCode(code).Active = (bit == 1)
        end
        if has("catchreshiramzekrom") then
            Tracker:FindObjectForCode("catchreshiram").Active = true
            Tracker:FindObjectForCode("catchzekrom").Active = true
        end
    end
end

function updatePokemon()
    Tracker:FindObjectForCode("static_visibility").CurrentStage = 1
    CAUGHT = CAUGHT or {}
    SEEN = SEEN or {}
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
    
    local regionObjects = {}
    local baseCounts = {}
    local pendingDecrements = {}
    
    for region_key, location in pairs(ENCOUNTER_MAPPING) do
        regionObjects[region_key] = Tracker:FindObjectForCode(location)
        baseCounts[region_key] = #REGION_ENCOUNTERS[region_key]
        pendingDecrements[region_key] = 0
    end
    
    for dex_number, locations in pairs(POKEMON_TO_LOCATIONS) do
        local dexVisibilityCode = Tracker:FindObjectForCode("dexsanity_visibility_" .. dex_number).Active
        local dexSentCode = Tracker:FindObjectForCode("dexsanity_sent_" .. dex_number).Active
        
        local is_caught = table_contains(CAUGHT, dex_number)
        local is_seen = false
        
        if has("all_pokemon_seen") then
            is_seen = true
        else
            is_seen = table_contains(SEEN, dex_number)
        end
        
        local should_decrement = false
        if is_caught then
            should_decrement = true
        elseif has("encounter_tracking_minimal") and (dexSentCode or not dexVisibilityCode) then
            should_decrement = true
        elseif has("encounter_tracking_seen") and not dexVisibilityCode and is_seen then
            should_decrement = true
        end
        
        if has("hint_tracking_on_plus") and SAVED_HINTS ~= nil then
            local padded_dex_number = 600000 + dex_number
                
            for _, hint in ipairs(SAVED_HINTS or {}) do
                if hint.finding_player == PLAYER_ID then
                    if padded_dex_number == hint.location then
                        if hint.item_flags ~= 1 and hint.item_flags ~= 3 and hint.item_flags ~= 5 then
                            should_decrement = true
                            break
                        end
                    end
                end
                if should_decrement then break end
            end
        end
        
        if should_decrement then
            for _, location in pairs(locations) do
                local object_name = ENCOUNTER_MAPPING[location]
                if object_name ~= nil then
                    local object = Tracker:FindObjectForCode(object_name)
                    if object then
                        pendingDecrements[location] = pendingDecrements[location] + 1
                    end
                end
            end
        end
    end
    for region_key, object in pairs(regionObjects) do
        object.AvailableChestCount = baseCounts[region_key] - pendingDecrements[region_key]
    end
end

-- Auto-tabbing
function updateMap(map_id)
    if has("automap_on") then
        local tabs = MAP_MAPPING[map_id]
        if tabs then
            for _, tab in ipairs(tabs) do
                Tracker:UiHint("ActivateTab", tab)
            end
        end
    end
end

function toggleHints()
    if has("hint_tracking_off") then
        updatePokemon()
        resetHints()
    elseif has("hint_tracking_on") then
        updatePokemon()
        resetHints()
        updateHints()
    elseif has("hint_tracking_on_plus") then
        updatePokemon()
        updateHints()
    end
end

function resetHints()
    CLEARED_HINTS = {}
    for _, hint in ipairs(SAVED_HINTS or {}) do
        if hint.finding_player == PLAYER_ID then
            local mapped = LOCATION_MAPPING[hint.location]
            local locations = (type(mapped) == "table") and mapped or { mapped }
    
            for _, location in ipairs(locations) do
                -- Only sections (items don't support Highlight)
                if location:sub(1, 1) == "@" then
                    local obj = Tracker:FindObjectForCode(location)
                    local final_value = obj.ChestCount
                    local cleared = CLEARED_LOCATIONS[location] or 0
                    final_value = final_value - cleared
                    obj.AvailableChestCount = final_value
                    obj.Highlight = 0
                end
            end
        end
    end
    
    for _, location in pairs(ENCOUNTER_MAPPING) do
        if location and location:sub(1, 1) == "@" then
            local obj = Tracker:FindObjectForCode(location)
            obj.Highlight = 0
        end
    end
end

CLEARED_HINTS = {}
function updateHints()
    if not Highlight then return end
    if has("hint_tracking_off") then return end

    CLEARED_HINTS = {}

    local tracking_plus = has("hint_tracking_on_plus")

    ---- We are leaving this here for now to test this later on: https://discord.com/channels/937157230963339364/1487592945703063562
    --if has("keyitem_priority_true") then
    --    for _, location in ipairs(PRIORITY_LOCATIONS) do
    --        loc = Tracker:FindObjectForCode(location)
    --        if loc.AvailableChestCount == 0 then
    --            loc.Highlight = 0
    --        else
    --            loc.Highlight = 3
    --        end
    --    end
    --else
	--
    --    for _, location in ipairs(PRIORITY_LOCATIONS) do
    --        Tracker:FindObjectForCode(location).Highlight = 0
    --    end
    --end
    
    for _, hint in ipairs(SAVED_HINTS) do
        if hint.finding_player == PLAYER_ID then
            local mapped = LOCATION_MAPPING[hint.location]
            local incoming_val = HIGHLIGHT_LEVEL[hint.item_flags]

            -- Special handling for Pokémon locations (600001–600649)
            if hint.location >= 600001 and hint.location <= 600649 then
                local poke_id = hint.location - 600000
                local poke_locations = POKEMON_TO_LOCATIONS[poke_id]

                if poke_locations then
                    for _, encounter_key in pairs(poke_locations) do
                        local mapped_location = ENCOUNTER_MAPPING[encounter_key]
                        if mapped_location and mapped_location:sub(1, 1) == "@" then
                            local obj = Tracker:FindObjectForCode(mapped_location)
    
                            if tracking_plus then
                                if incoming_val == 3 then
                                    obj.Highlight = incoming_val
                                end
                            else
                                local current_val = obj.Highlight
                                if current_val == nil or HIGHLIGHT_PRIORITY[incoming_val] < HIGHLIGHT_PRIORITY[current_val] then
                                    obj.Highlight = incoming_val
                                end
                            end
                        end
                    end
                end

                goto continue_hint
            end

            local locations = (type(mapped) == "table") and mapped or { mapped }

            for _, location in ipairs(locations) do
                if location:sub(1, 1) == "@" then
                    local obj = Tracker:FindObjectForCode(location)

                    if tracking_plus then
                        if incoming_val == 3 then
                            obj.Highlight = incoming_val
                        else
                            local current_total = CLEARED_HINTS[location] or 0
                            CLEARED_HINTS[location] = current_total + 1
                        end
                    else
                        local current_val = obj.Highlight
                        if current_val == nil or HIGHLIGHT_PRIORITY[incoming_val] < HIGHLIGHT_PRIORITY[current_val] then
                            obj.Highlight = incoming_val
                        end
                    end
                end
            end

            ::continue_hint::
        end
    end

    if tracking_plus then
        for location, count in pairs(CLEARED_HINTS) do
            local obj = Tracker:FindObjectForCode(location)
            local cleared = CLEARED_LOCATIONS[location] or 0
            obj.AvailableChestCount = obj.ChestCount - count - cleared
            if obj.AvailableChestCount == 0 then
                obj.Highlight = 0
            end
        end
    end

    for _, location in pairs(ENCOUNTER_MAPPING) do
        if location and location:sub(1, 1) == "@" then
            local obj = Tracker:FindObjectForCode(location)
            if obj and obj.AvailableChestCount == 0 then
                obj.Highlight = 0
            end
        end
    end
end

-- add AP callbacks
Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddSetReplyHandler("notify handler", onNotify)
Archipelago:AddRetrievedHandler("notify launch handler", onNotify)