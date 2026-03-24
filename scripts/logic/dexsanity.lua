function levelup(value)
    if has("consider_evolutions_false") then
        return AccessibilityLevel.SequenceBreak
    end

    local in_vanilla_east = 0
    if not has("adjustlevels_wilds") then
        in_vanilla_east = Tracker:FindObjectForCode("@Route 15 Access").AccessibilityLevel
    end
    local region_3 = Tracker:FindObjectForCode("@Pinwheel Forest Outside Access").AccessibilityLevel
    local region_4 = Tracker:FindObjectForCode("@Castelia City Access").AccessibilityLevel
    local region_5 = Tracker:FindObjectForCode("@Desert Resort Access").AccessibilityLevel
    local region_6 = math.max(
            Tracker:FindObjectForCode("@Undella Town Access").AccessibilityLevel,
            Tracker:FindObjectForCode("@Mistralton Cave Access").AccessibilityLevel,
            Tracker:FindObjectForCode("@Chargestone Cave Access").AccessibilityLevel) 
    local region_7 =  math.max(
            Tracker:FindObjectForCode("@Route 13 Access").AccessibilityLevel,
            Tracker:FindObjectForCode("@Twist Mountain Access").AccessibilityLevel)
    local region_8 =  math.max(
            Tracker:FindObjectForCode("@Opelucid City Access").AccessibilityLevel,
            in_vanilla_east)
    local region_9 =  math.max(
            Tracker:FindObjectForCode("@Victory Road Access").AccessibilityLevel,
            in_vanilla_east)
    local region_10 =  math.max(
            Tracker:FindObjectForCode("@Pokémon League Access").AccessibilityLevel,
            in_vanilla_east)
    local region_post = Tracker:FindObjectForCode("@Victory Road Access").AccessibilityLevel
    local region_alder = Tracker:FindObjectForCode("@Victory Road Access").AccessibilityLevel
    
    local index = math.floor(value / 5)
    
    if index < 3 then
        return AccessibilityLevel.Normal
    elseif index == 3 then
        return math.max(region_3, AccessibilityLevel.SequenceBreak)
    elseif index == 4 then
        return math.max(region_4, AccessibilityLevel.SequenceBreak)
    elseif index == 5 then
        return math.max(region_5, AccessibilityLevel.SequenceBreak)
    elseif index == 6 then
        return math.max(region_6, AccessibilityLevel.SequenceBreak)
    elseif index == 7 then
        return math.max(region_7, AccessibilityLevel.SequenceBreak)
    elseif index == 8 then
        return math.max(region_8, AccessibilityLevel.SequenceBreak)
    elseif index == 9 then
        return math.max(region_9, AccessibilityLevel.SequenceBreak)
    elseif index == 10 then
        return math.max(region_10, AccessibilityLevel.SequenceBreak)
    elseif index >= 11 and index <= 14 then
        return math.max(region_post, AccessibilityLevel.SequenceBreak)
    elseif index >= 15 and index <= 19 then
        return math.max(region_alder, AccessibilityLevel.SequenceBreak)
    else
        print("The value "..value.." is not expected for level_up. Please contact palex00")
    end
end

function evolve_item(value)
    value = tonumber(value)
    if has("consider_evolutions_true") then
        if value == 80 or value == 81 then
            return Tracker:FindObjectForCode("@Twist Mountain Access").AccessibilityLevel
        elseif value == 82 or value == 84 or value == 85 then
            return Tracker:FindObjectForCode("@Castelia City Access").AccessibilityLevel
        elseif value == 83 or value == 233 then
            return Tracker:FindObjectForCode("@Chargestone Cave Access").AccessibilityLevel
        elseif value == 107 or value == 108 or value == 109 then
            return Tracker:FindObjectForCode("@Route 10 Access").AccessibilityLevel
        elseif value == 110 or value == 221 or value == 235 or value == 321 or value == 325 then
            return Tracker:FindObjectForCode("@Route 9 Access").AccessibilityLevel
        elseif value == 226 or value == 227 or value == 252 or value == 322 or value == 323 or value == 324 or value == 325 or value == 537 then
            return Tracker:FindObjectForCode("@Undella Town Access").AccessibilityLevel
        elseif value == 326 or value == 327 then
            return Tracker:FindObjectForCode("@Giant Chasm Access").AccessibilityLevel
        else
            print("The value "..value.." is not expected for evolve_item. Please contact palex00")
        end
    else
        if value == 80 or value == 81 then
            if Tracker:FindObjectForCode("@Twist Mountain Access").AccessibilityLevel >= 5 then
                return AccessibilityLevel.SequenceBreak
            end
        elseif value == 82 or value == 84 or value == 85 then
            if Tracker:FindObjectForCode("@Castelia City Access").AccessibilityLevel >= 5 then
                return AccessibilityLevel.SequenceBreak
            end
        elseif value == 83 or value == 233 then
            if Tracker:FindObjectForCode("@Chargestone Cave Access").AccessibilityLevel >= 5 then
                return AccessibilityLevel.SequenceBreak
            end
        elseif value == 107 or value == 108 or value == 109 then
            if Tracker:FindObjectForCode("@Route 10 Access").AccessibilityLevel >= 5 then
                return AccessibilityLevel.SequenceBreak
            end
        elseif value == 110 or value == 221 or value == 235 or value == 321 or value == 325 then
            if Tracker:FindObjectForCode("@Route 9 Access").AccessibilityLevel >= 5 then
                return AccessibilityLevel.SequenceBreak
            end
        elseif value == 226 or value == 227 or value == 252 or value == 322 or value == 323 or value == 324 or value == 325 or value == 537 then
            if Tracker:FindObjectForCode("@Undella Town Access").AccessibilityLevel >= 5 then
                return AccessibilityLevel.SequenceBreak
            end
        elseif value == 326 or value == 327 then
            if Tracker:FindObjectForCode("@Giant Chasm Access").AccessibilityLevel >= 5 then
                return AccessibilityLevel.SequenceBreak
            end
        else
            print("The value "..value.." is not expected for evolve_item. Please contact palex00")
        end
    end
    -- See here: https://github.com/SparkyDaDoggo/Archipelago/blob/main/worlds/pokemon_bw/data/pokemon/evolution_methods.py
end

function evolve_friendship(value)
    local friendship_appraiser = Tracker:FindObjectForCode("@Nacrene City Access").AccessibilityLevel

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
    local move_relearner = Tracker:FindObjectForCode("@Mistralton City Access").AccessibilityLevel
    if has("consider_evolutions_false") then
        return AccessibilityLevel.SequenceBreak
    else
        return math.max(move_relearner, AccessibilityLevel.SequenceBreak)
    end
end

function searchMon()
    if POKEMON_TO_LOCATIONS ~= nil then
	    Tracker:FindObjectForCode("location_visibility").CurrentStage = 2
        Tracker:FindObjectForCode("static_visibility").CurrentStage = 0
        Tracker:FindObjectForCode("no_wild_encounters_found").Active = false
        
        for region_key, location in pairs(ENCOUNTER_MAPPING) do
            local object = Tracker:FindObjectForCode(location)
            object.AvailableChestCount = 0
        end
        
        local dex1 = Tracker:FindObjectForCode("dexsearch_digit1").CurrentStage
        local dex2 = Tracker:FindObjectForCode("dexsearch_digit2").CurrentStage
        local dex3 = Tracker:FindObjectForCode("dexsearch_digit3").CurrentStage
        local dexID = dex1 * 100 + dex2 * 10 + dex3
        
        Tracker:FindObjectForCode("search_ID_result").CurrentStage = dexID
        
        local locations = POKEMON_TO_LOCATIONS[dexID]
        
        if not locations then
            if dexID == 0 then
                updatePokemon()
                Tracker:FindObjectForCode("go").CurrentStage = 0
                return
            else
                print("The Pokemon with the ID "..dexID.." cannot be caught in the wild!")
                Tracker:FindObjectForCode("go").CurrentStage = 0
                Tracker:FindObjectForCode("no_wild_encounters_found").Active = true
                return
            end
        end
    
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
    
    Tracker:FindObjectForCode("go").CurrentStage = 0
end

function static_encounter()
    if has("consider_statics_true") then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
    end
end