function levelup(value)
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
    
    -- See here: https://github.com/SparkyDaDoggo/Archipelago/blob/main/worlds/pokemon_bw/data/pokemon/evolution_methods.py
end

function evolve_friendship(value)
    return AccessibilityLevel.Normal
end

function evolve_area(area)
    return Tracker:FindObjectForCode("@"..area.." Access").AccessibilityLevel
end

function evolve_move()
    return AccessibilityLevel.Normal
end