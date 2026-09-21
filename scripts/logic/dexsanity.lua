LEVEL_REGIONS = {}
for bucket = 0, 20 do
    LEVEL_REGIONS[bucket] = {}
end

function levelup(level)
    if has("consider_evolutions_false") then
        return AccessibilityLevel.SequenceBreak
    end
    for _, code in ipairs(LEVEL_REGIONS[tonumber(level) // 5]) do
        if Tracker:FindObjectForCode(code).AccessibilityLevel == AccessibilityLevel.Normal then
            return AccessibilityLevel.Normal
        end
    end
    return AccessibilityLevel.SequenceBreak
end

function evolve_item(value)
    value = tonumber(value)
    if has("consider_evolutions_true") then
        if value == 80 or value == 81 then
            return Tracker:FindObjectForCode("@Twist Mountain Outside 3F West Footbridge Access").AccessibilityLevel
        elseif value == 82 or value == 84 or value == 85 then
            return Tracker:FindObjectForCode("@Castelia City Thumb Pier Access").AccessibilityLevel
        elseif value == 83 or value == 233 then
            return Tracker:FindObjectForCode("@Chargestone Cave 1F Access").AccessibilityLevel
        elseif value == 107 or value == 108 or value == 109 then
            return Tracker:FindObjectForCode("@Route 10 Access").AccessibilityLevel
        elseif value == 110 or value == 221 or value == 235 or value == 321 or value == 325 then
            return Tracker:FindObjectForCode("@Shopping Mall Nine Access").AccessibilityLevel
        elseif value == 226 or value == 227 or value == 252 or value == 322 or value == 323 or value == 324 or value == 325 or value == 537 then
            return Tracker:FindObjectForCode("@The Riches' Villa Access").AccessibilityLevel
        elseif value == 326 or value == 327 then
            return Tracker:FindObjectForCode("@Giant Chasm Entrance Cave Access").AccessibilityLevel
        else
            print("The value "..value.." is not expected for evolve_item. Please contact palex00")
        end
    else
        if value == 80 or value == 81 then
            if Tracker:FindObjectForCode("@Twist Mountain Outside 3F West Footbridge Access").AccessibilityLevel >= 5 then
                return AccessibilityLevel.SequenceBreak
            end
        elseif value == 82 or value == 84 or value == 85 then
            if Tracker:FindObjectForCode("@Castelia City Thumb Pier Access").AccessibilityLevel >= 5 then
                return AccessibilityLevel.SequenceBreak
            end
        elseif value == 83 or value == 233 then
            if Tracker:FindObjectForCode("@Chargestone Cave 1F Access").AccessibilityLevel >= 5 then
                return AccessibilityLevel.SequenceBreak
            end
        elseif value == 107 or value == 108 or value == 109 then
            if Tracker:FindObjectForCode("@Route 10 Access").AccessibilityLevel >= 5 then
                return AccessibilityLevel.SequenceBreak
            end
        elseif value == 110 or value == 221 or value == 235 or value == 321 or value == 325 then
            if Tracker:FindObjectForCode("@Shopping Mall Nine Access").AccessibilityLevel >= 5 then
                return AccessibilityLevel.SequenceBreak
            end
        elseif value == 226 or value == 227 or value == 252 or value == 322 or value == 323 or value == 324 or value == 325 or value == 537 then
            if Tracker:FindObjectForCode("@The Riches' Villa Access").AccessibilityLevel >= 5 then
                return AccessibilityLevel.SequenceBreak
            end
        elseif value == 326 or value == 327 then
            if Tracker:FindObjectForCode("@Giant Chasm Entrance Cave Access").AccessibilityLevel >= 5 then
                return AccessibilityLevel.SequenceBreak
            end
        else
            print("The value "..value.." is not expected for evolve_item. Please contact palex00")
        end
    end
    -- See here: https://github.com/SparkyDaDoggo/Archipelago/blob/main/worlds/pokemon_bw/data/pokemon/evolution_methods.py
end

function evolve_friendship(value)
    local friendship_appraiser = Tracker:FindObjectForCode("@Nacrene City South East Left House Access").AccessibilityLevel

    if has("consider_evolutions_false") then
        return AccessibilityLevel.SequenceBreak
    else
        return math.max(friendship_appraiser, AccessibilityLevel.SequenceBreak)
    end
end

function evolve_area(area)
    local access = Tracker:FindObjectForCode("@"..area.." Access").AccessibilityLevel
    if has("consider_evolutions_false") then
        if access >= 5 then
            return AccessibilityLevel.SequenceBreak
        else
            return AccessibilityLevel.None
        end
    else
        return access
    end
end

function evolve_move()
    local move_reminder = Tracker:FindObjectForCode("@Mistralton City East House Access").AccessibilityLevel
    if has("consider_evolutions_false") then
        return AccessibilityLevel.SequenceBreak
    else
        return math.max(move_reminder, AccessibilityLevel.SequenceBreak)
    end
end


SEARCH_VISIBILITY_STAGES = {
    static_visibility = 0,
    trade_visibility = 0, -- we still want statics and trades even if they're not in logic because why not :D
    location_visibility = 2, -- encounters are set to ONLY during a search
}
-- we track the stages before the search
VISIBILITY_BEFORE_SEARCH = nil

function showSearchVisibility() -- helper that sets the correct stages for the search
    if VISIBILITY_BEFORE_SEARCH == nil then
        VISIBILITY_BEFORE_SEARCH = {}
        for code in pairs(SEARCH_VISIBILITY_STAGES) do
            VISIBILITY_BEFORE_SEARCH[code] = Tracker:FindObjectForCode(code).CurrentStage
        end
    end
    for code, stage in pairs(SEARCH_VISIBILITY_STAGES) do
        Tracker:FindObjectForCode(code).CurrentStage = stage
    end
end

function restoreSearchVisibility() -- helper that sets the visibilities back to what they were before the search
    if VISIBILITY_BEFORE_SEARCH ~= nil then
        for code, stage in pairs(VISIBILITY_BEFORE_SEARCH) do
            Tracker:FindObjectForCode(code).CurrentStage = stage
        end
        VISIBILITY_BEFORE_SEARCH = nil
    end
end

function searchMon()
    if POKEMON_TO_LOCATIONS ~= nil then
        showSearchVisibility()
        Tracker:FindObjectForCode("no_wild_encounters_found").Active = false
        
        for region_key, location in pairs(ENCOUNTER_MAPPING) do
            local object = Tracker:FindObjectForCode(location)
            object.AvailableChestCount = 0
        end
        
        local dex1 = Tracker:FindObjectForCode("dexsearch_digit1").CurrentStage
        local dex2 = Tracker:FindObjectForCode("dexsearch_digit2").CurrentStage
        local dex3 = Tracker:FindObjectForCode("dexsearch_digit3").CurrentStage
        local dexID = dex1 * 100 + dex2 * 10 + dex3
        -- stage 0 is all forms
        local form = -1
        local form_item = Tracker:FindObjectForCode("dexsearch_form_" .. dexID)
        if form_item then
            form = form_item.CurrentStage - 1
        end
        
        Tracker:FindObjectForCode("search_ID_result").CurrentStage = dexID
        
        local found = false
        for pokemon_id, locations in pairs(POKEMON_TO_LOCATIONS) do
            if (pokemon_id & 0x7FF) == dexID and (form == -1 or (pokemon_id >> 11) == form) then
                found = true
                for _, location in ipairs(locations) do
                    local object_name = ENCOUNTER_MAPPING[location]
                    print(object_name)
                    if object_name then
                        local object = Tracker:FindObjectForCode(object_name)
                        if object then
                            object.AvailableChestCount = object.AvailableChestCount + 1
                        end
                    end
                end
            end
        end
        
        if not found then
            if dexID == 0 then
                restoreSearchVisibility()
                updatePokemon()
                Tracker:FindObjectForCode("go").CurrentStage = 0
                return
            else
                print("The Pokemon with the ID "..dexID.." (form "..form..") cannot be caught in the wild!")
                Tracker:FindObjectForCode("go").CurrentStage = 0
                Tracker:FindObjectForCode("no_wild_encounters_found").Active = true
                return
            end
        end
    end
    
    Tracker:FindObjectForCode("go").CurrentStage = 0
end

function searchReset()
    local form_item = Tracker:FindObjectForCode("dexsearch_form_" .. getDigits("dexsearch_digit1", "dexsearch_digit2", "dexsearch_digit3"))
    if form_item then
        form_item.CurrentStage = 0
    end
    Tracker:FindObjectForCode("dexsearch_digit1").CurrentStage = 0
    Tracker:FindObjectForCode("dexsearch_digit2").CurrentStage = 0
    Tracker:FindObjectForCode("dexsearch_digit3").CurrentStage = 0
    searchMon()
    restoreSearchVisibility()
    Tracker:FindObjectForCode("search_ID_result").CurrentStage = 0
    Tracker:FindObjectForCode("search_reset").CurrentStage = 0
end

function static_encounter()
    if has("consider_statics_true") then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
    end
end

function trade(id)
    local caught = has("caught_"..id)
    if has("consider_trades_true") then
        return (caught and AccessibilityLevel.Normal) or AccessibilityLevel.Inspect
    end
    return (caught and AccessibilityLevel.SequenceBreak) or AccessibilityLevel.None
end