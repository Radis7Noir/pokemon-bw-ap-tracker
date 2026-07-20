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
        [10] = Highlight.Unspecified,
        [20] = Highlight.Avoid,
        [30] = Highlight.Priority,
        [40] = Highlight.None,
        [100] = Highlight.Unspecified,
        [101] = Highlight.Priority,
        [102] = Highlight.NoPriority,
        [103] = Highlight.Priority,
        [104] = Highlight.Avoid,
        [105] = Highlight.Priority,
        [106] = Highlight.NoPriority,
        [107] = Highlight.Priority,
    }
end

HIGHLIGHT_PRIORITY =  {
    [Highlight.Priority] = 1, -- priority
    [Highlight.NoPriority] = 2, -- useful
    [Highlight.Avoid] = 3, -- trap
    [Highlight.Unspecified] = 4, -- filler
    [Highlight.None] = 5 -- none
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
		Thundurus_Roamer = 642,
		Dwebble_R13 = 557,
		Dwebble_WC = 557,
		Dwebble_CC = 557,
    	Dwebble_DY = 557
		
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
	local hm_with_badges_found = false
	local add_rock_smash_found = false
	local add_ss_ticket_found = false
	local add_pass_found = false
    local extra_cut_trees_found = false
    local move_strength_boulders_found = false
    local dark_areas_found = false

    local dark_area_list = {
        ["Striaton Gym"] = Tracker:FindObjectForCode("dark_areas_striaton_gym"),
        ["Nacrene Gym"] = Tracker:FindObjectForCode("dark_areas_nacrene_gym"),
        ["Castelia Gym"] = Tracker:FindObjectForCode("dark_areas_castelia_gym"),
        ["Nimbasa Gym"] = Tracker:FindObjectForCode("dark_areas_nimbasa_gym"),
        ["Driftveil Gym"] = Tracker:FindObjectForCode("dark_areas_driftveil_gym"),
        ["Mistralton Gym"] = Tracker:FindObjectForCode("dark_areas_mistralton_gym"),
        ["Icirrus Gym"] = Tracker:FindObjectForCode("dark_areas_icirrus_gym"),
        ["Opelucid Gym"] = Tracker:FindObjectForCode("dark_areas_opelucid_gym"),
        ["Dreamyard Basement"] = Tracker:FindObjectForCode("dark_areas_dreamyard_basement"),
        ["Wellspring Cave 1F"] = Tracker:FindObjectForCode("dark_areas_wellspring_cave_1f"),
        ["Wellspring Cave B1F"] = Tracker:FindObjectForCode("dark_areas_wellspring_cave_b1f"),
        ["Pinwheel Forest Inside"] = Tracker:FindObjectForCode("dark_areas_pinwheel_forest"),
        ["Relic Castle Pre-Sand Room"] = Tracker:FindObjectForCode("dark_areas_relic_castle_pre"),
        ["Relic Castle Post-Sand Room"] = Tracker:FindObjectForCode("dark_areas_relic_castle_post"),
        ["Cold Storage"] = Tracker:FindObjectForCode("dark_areas_cold_storage"),
        ["Mistralton Cave"] = Tracker:FindObjectForCode("dark_areas_mistralton_cave"),
        ["Guidance Chamber"] = Tracker:FindObjectForCode("dark_areas_guidance_chamber"),
        ["Chargestone Cave"] = Tracker:FindObjectForCode("dark_areas_chargestone_cave"),
        ["Celestial Tower"] = Tracker:FindObjectForCode("dark_areas_celestial_tower"),
        ["Twist Mountain"] = Tracker:FindObjectForCode("dark_areas_twist_mountain"),
        ["Dragonspiral Tower"] = Tracker:FindObjectForCode("dark_areas_dragonspiral_tower"),
        ["Challengers Cave"] = Tracker:FindObjectForCode("dark_areas_challengers"),
        ["Victory Road"] = Tracker:FindObjectForCode("dark_areas_victory_road"),
        ["Giant Chasm"] = Tracker:FindObjectForCode("dark_areas_giant_chasm"),
    }

    local default_dark_areas = {
        ["Wellspring Cave B1F"] = true,
        ["Mistralton Cave"] = true,
        ["Challengers Cave"] = true,
    }

    for k, v in pairs(slot_data) do
        if k == "dark_areas" then
            dark_areas_found = true

            local area_in_list = {}
            for _, area in ipairs(v) do
                area_in_list[area] = true
            end

     -- we only set once this way
            for area, obj in pairs(dark_area_list) do
                obj.CurrentStage = area_in_list[area] and 1 or 0
            end
        end
    end

    if not dark_areas_found then
        for area, obj in pairs(dark_area_list) do
            obj.CurrentStage = default_dark_areas[area] and 1 or 0
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
        elseif k == "shuffle_badges" then
            local item = Tracker:FindObjectForCode("shuffle_badges")
            if v == "vanilla" then
                item.CurrentStage = 0
            elseif v == "shuffle" then
                item.CurrentStage = 1
            elseif v == "anything" then
                item.CurrentStage = 2
            end
        elseif k == "plugin_options" then
            local extra_logic = v.extra_logic or {}
            if extra_logic.hm_with_badges ~= nil then
                hm_with_badges_found = true
                local cut_requirement = Tracker:FindObjectForCode("hm01cut")
                local surf_requirement = Tracker:FindObjectForCode("hm03surf")
                local strength_requirement = Tracker:FindObjectForCode("hm04strength")
                local waterfall_requirement = Tracker:FindObjectForCode("hm05waterfall")
                local dive_requirement = Tracker:FindObjectForCode("hm06dive")
                local rock_smash_requirement = Tracker:FindObjectForCode("tm94rocksmash")
                if extra_logic.hm_with_badges == true then
                    cut_requirement.CurrentStage = 0
                    surf_requirement.CurrentStage = 0
                    strength_requirement.CurrentStage = 0
                    waterfall_requirement.CurrentStage = 0
                    dive_requirement.CurrentStage = 0
                    rock_smash_requirement.CurrentStage = 0
                else
                    cut_requirement.CurrentStage = 1
                    surf_requirement.CurrentStage = 1
                    strength_requirement.CurrentStage = 1
                    waterfall_requirement.CurrentStage = 1
                    dive_requirement.CurrentStage = 1
                    rock_smash_requirement.CurrentStage = 1
                end
            end
            if extra_logic.add_rock_smash ~= nil or extra_logic.add_rock_smash_musharna ~= nil then
                add_rock_smash_found = true
                local item = Tracker:FindObjectForCode("add_rocksmash")
                if extra_logic.add_rock_smash == true and extra_logic.add_rock_smash_musharna == true then
                    item.CurrentStage = 2
                elseif extra_logic.add_rock_smash == true then
                    item.CurrentStage = 1
                else
                    item.CurrentStage = 0
                end
            end
            if extra_logic.add_ss_ticket ~= nil then
                add_ss_ticket_found = true
                local item = Tracker:FindObjectForCode("add_ssticket")
                item.CurrentStage = extra_logic.add_ss_ticket == true and 1 or 0
            end
            if extra_logic.add_pass ~= nil then
                add_pass_found = true
                local item = Tracker:FindObjectForCode("add_pass")
                item.CurrentStage = extra_logic.add_pass == true and 1 or 0
            end
            if extra_logic.extra_cut_trees ~= nil or extra_logic.extra_cut_trees_kyurem ~= nil then
                extra_cut_trees_found = true
                local item = Tracker:FindObjectForCode("ex_cut_trees")
                if extra_logic.extra_cut_trees == true and extra_logic.extra_cut_trees_kyurem == true then
                    item.CurrentStage = 2
                elseif extra_logic.extra_cut_trees == true then
                    item.CurrentStage = 1
                else
                    item.CurrentStage = 0
                end
            end
            if extra_logic.move_strength_boulders ~= nil or extra_logic.move_strength_boulders_vi_road ~= nil then
                move_strength_boulders_found = true
                local item = Tracker:FindObjectForCode("mo_strength_boulders")
                if extra_logic.move_strength_boulders == true and extra_logic.move_strength_boulders_vi_road == true then
                    item.CurrentStage = 2
                elseif extra_logic.move_strength_boulders == true then
                    item.CurrentStage = 1
                else
                    item.CurrentStage = 0
                end
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

	if not hm_with_badges_found then
		Tracker:FindObjectForCode("hm01cut").CurrentStage = 1
		Tracker:FindObjectForCode("hm03surf").CurrentStage = 1
		Tracker:FindObjectForCode("hm04strength").CurrentStage = 1
		Tracker:FindObjectForCode("hm05waterfall").CurrentStage = 1
		Tracker:FindObjectForCode("hm06dive").CurrentStage = 1
		Tracker:FindObjectForCode("tm94rocksmash").CurrentStage = 1
	end
	if not add_rock_smash_found then
		Tracker:FindObjectForCode("add_rocksmash").CurrentStage = 0
	end
	if not add_ss_ticket_found then
		Tracker:FindObjectForCode("add_ssticket").CurrentStage = 0
	end
	if not add_pass_found then
		Tracker:FindObjectForCode("add_pass").CurrentStage = 0
	end
	if not extra_cut_trees_found then
		Tracker:FindObjectForCode("ex_cut_trees").CurrentStage = 0
	end
	if not move_strength_boulders_found then
		Tracker:FindObjectForCode("mo_strength_boulders").CurrentStage = 0
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
            MAP        = makeID("map_"),
            HINT       = "_read_hints_" .. suffix,
            WILD_IDS   = makeID("wild_ids_"),
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
        elseif type == "rock_smash_tm" then
            obj.AcquiredCount = 0
            Tracker:FindObjectForCode("tm94rocksmash").Active = false
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
			elseif v[2] == "rock_smash_tm" then
                obj.AcquiredCount = obj.AcquiredCount + obj.Increment
                Tracker:FindObjectForCode("tm94rocksmash").Active = true
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
            updateCaught()
        elseif key == IDs.SEEN then
            SEEN = value
            updateSeen()
        elseif key == IDs.MAP and old_value ~= nil then
            MAP_ID = value
            updateMap()
        elseif key == IDs.MAP and old_value == nil then
            MAP_ID = value
        elseif key == IDs.HINT then
            SAVED_HINTS = value
            updateHints()
            updatePokemon()
        elseif key == IDs.WILD_IDS and old_value ~= nil then
            updateWildBattle(value)
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

function updateSeen()
    Tracker:FindObjectForCode("seen_pokemon").AcquiredCount = #SEEN
    updatePokemon()
end

function updateCaught()
    for i = 1, 649 do
        if table_contains(CAUGHT, i) then
            Tracker:FindObjectForCode("caught_"..i).Active = true
        else
            Tracker:FindObjectForCode("caught_"..i).Active = false
        end
    end
    updatePokemon()
end

function updateWildBattle(value)
    if Tracker:FindObjectForCode("dexsanity").AcquiredCount == 0 then
        return
    end
    
    print(dump_table(value))

    local id1 = value[1]
    local id2 = value[2]

    local check1 = false
    if id1 ~= 0 then
        local visibility1 = Tracker:FindObjectForCode("dexsanity_visibility_" .. id1).Active
        local sent1 = Tracker:FindObjectForCode("dexsanity_sent_" .. id1).Active
        check1 = visibility1 and not sent1
    end

    local check2 = false
    if id2 ~= 0 then
        local visibility2 = Tracker:FindObjectForCode("dexsanity_visibility_" .. id2).Active
        local sent2 = Tracker:FindObjectForCode("dexsanity_sent_" .. id2).Active
        check2 = visibility2 and not sent2
    end

    if check1 and check2 then
        Tracker:UiHint("ActivateTab", "Others")
        Tracker:UiHint("ActivateTab", " ")
        Tracker:UiHint("ActivateTab", "Double Dexsanity")
    elseif check1 and id2 == 0 then
        Tracker:UiHint("ActivateTab", "Others")
        Tracker:UiHint("ActivateTab", " ")
        Tracker:UiHint("ActivateTab", "Single Dexsanity")
    elseif check1 then
        Tracker:UiHint("ActivateTab", "Others")
        Tracker:UiHint("ActivateTab", " ")
        Tracker:UiHint("ActivateTab", "Right Dexsanity")
    elseif check2 then
        Tracker:UiHint("ActivateTab", "Others")
        Tracker:UiHint("ActivateTab", " ")
        Tracker:UiHint("ActivateTab", "Left Dexsanity")
    else
        updateMap()
    end
end

function updatePokemon()
    Tracker:FindObjectForCode("static_visibility").CurrentStage = 1
    CAUGHT = CAUGHT or {}
    SEEN = SEEN or {}

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
        
        if should_decrement == false then
            if has("hint_tracking_on_plus") and SAVED_HINTS ~= nil then
                local padded_dex_number = 600000 + dex_number
                for _, hint in pairs(SAVED_HINTS) do
                    if hint.finding_player == PLAYER_ID and hint.found == false then
                        if padded_dex_number == hint.location then
                            local level = 0
                            if hint.status == 0 then
                                level = HIGHLIGHT_LEVEL[100 + hint.item_flags]
                            else
                                level = HIGHLIGHT_LEVEL[hint.status]
                            end
                            if level ~= Highlight.Priority then
                                should_decrement = true
                                break
                            end
                        end
                    end
                    if should_decrement then break end
                end
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

    for _, location in pairs(ENCOUNTER_MAPPING) do
        if location and location:sub(1, 1) == "@" then
            local obj = Tracker:FindObjectForCode(location)
            if obj and obj.AvailableChestCount == 0 then
                obj.Highlight = 0
            end
        end
    end
end

-- Auto-tabbing
function updateMap()
    map_id = MAP_ID or 0
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
        resetHints()
        updateHints()
        updatePokemon()
    elseif has("hint_tracking_on_plus") then
        updateHints()
        updatePokemon()
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

    for _, locations in pairs(LOCATION_MAPPING) do
        for _, location in pairs(locations) do
            if location:sub(1, 1) == "@" then
                local obj = Tracker:FindObjectForCode(location)
                obj.Highlight = 0
            end
        end
    end
    for _, location in pairs(ENCOUNTER_MAPPING) do
        if location:sub(1, 1) == "@" then
            local obj = Tracker:FindObjectForCode(location)
            obj.Highlight = 0
        end
    end

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
            local incoming_val = 0
            
            if hint.status == 0 then
                incoming_val = HIGHLIGHT_LEVEL[100 + hint.item_flags]
            else
                incoming_val = HIGHLIGHT_LEVEL[hint.status]
            end

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
                                if hint.found == false then
                                    if incoming_val == Highlight.Priority then
                                        obj.Highlight = incoming_val
                                    end
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
                        if hint.found == false then
                            if incoming_val == Highlight.Priority then
                                obj.Highlight = incoming_val
                            else
                                local current_total = CLEARED_HINTS[location] or 0
                                CLEARED_HINTS[location] = current_total + 1
                            end
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
end

-- add AP callbacks
Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddSetReplyHandler("notify handler", onNotify)
Archipelago:AddRetrievedHandler("notify launch handler", onNotify)