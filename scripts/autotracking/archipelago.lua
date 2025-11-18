ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/utils.lua")
ScriptHost:LoadScript("scripts/autotracking/encounter_mapping.lua")

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
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}

function onClear(slot_data)
    print(string.format("called onClear, slot_data:\n%s", dump_table(slot_data)))
    SLOT_DATA = slot_data
    CUR_INDEX = -1
    LOCAL_ITEMS = {}
    GLOBAL_ITEMS = {}

    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] and v[2] then
            for _, code in ipairs(v[1]) do
                resetItem(code, v[2])
            end
        end
    end

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
         elseif k == "modify_logic" then
            local require_flash = Tracker:FindObjectForCode("require_flash")
            local require_dowsingmchn = Tracker:FindObjectForCode("require_dowsingmchn")
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
         elseif k == "version" then
            local game_version = Tracker:FindObjectForCode("game_version")
            if v == "white" then
                game_version.CurrentStage = 1
            else
                game_version.CurrentStage = 0
            end
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

-- add AP callbacks
Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
