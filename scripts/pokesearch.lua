SEARCH_VISIBILITY_STAGES = {
    static_visibility = 1,
    trade_visibility = 1, -- we still want statics and trades even if they're not in logic because why not :D
    seen_visibility = 0, -- special seens like zorua dex entry in castelia or form changes should be hidden
    item_visibility = 0,
    encounter_visibility = 1,
    trainer_visibility = 0
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
    if FORM_TO_LOCATIONS ~= nil then
        showSearchVisibility()
        Tracker:FindObjectForCode("no_wild_encounters_found").Active = false
        
        for region_key, locations in pairs(ENCOUNTER_MAPPING) do
            for _, location in ipairs(locations) do
                Tracker:FindObjectForCode(location).AvailableChestCount = 0
            end
        end
        
        local dex1 = Tracker:FindObjectForCode("dexsearch_digit1").CurrentStage
        local dex2 = Tracker:FindObjectForCode("dexsearch_digit2").CurrentStage
        local dex3 = Tracker:FindObjectForCode("dexsearch_digit3").CurrentStage
        local dexID = dex1 * 100 + dex2 * 10 + dex3
        -- stage 0 is all forms
        local form = -1
        if FORM_SEARCH[dexID] then
            form = Tracker:FindObjectForCode("dexsearch_form_" .. dexID).CurrentStage - 1
        end
        
        Tracker:FindObjectForCode("search_ID_result").CurrentStage = dexID

        -- we set a flag and read it on searchReset() to freeze the reset button on the red stage
        if dexID ~= 0 then
            IGNORE_RESET = true
            Tracker:FindObjectForCode("search_reset").CurrentStage = 1
            IGNORE_RESET = false
        end

        local found = false
        for pokemon_id, locations in pairs(FORM_TO_LOCATIONS) do
            if (pokemon_id & 0x7FF) == dexID and (form == -1 or (pokemon_id >> 11) == form) then
                found = true
                for _, location in ipairs(locations) do
                    for _, object_name in ipairs(ENCOUNTER_MAPPING[location] or {}) do
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
    if IGNORE_RESET then return end -- we ignore the stage change made by searchMon()
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

function pokesearchShortcut(shortcut)
    if string.sub(shortcut, 1, 11) == "pokesearch_" then
        local digit1, digit2, digit3 = shortcut:match("pokesearch_(.-)_(.-)_(.+)")
        Tracker:FindObjectForCode("dexsearch_digit1").CurrentStage = tonumber(digit1)
        Tracker:FindObjectForCode("dexsearch_digit2").CurrentStage = tonumber(digit2)
        Tracker:FindObjectForCode("dexsearch_digit3").CurrentStage = tonumber(digit3)
        Tracker:UiHint("ActivateTab", "Unova")
        Tracker:FindObjectForCode(shortcut).Active = false
        searchMon()
    end
end