Tracker.AllowDeferredLogicUpdate = true

-- Items
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/events.json")
Tracker:AddItems("items/events_hosted.json")
Tracker:AddItems("items/options.json")
Tracker:AddItems("items/pokemon.json")
Tracker:AddItems("items/dexsanity_visibility.json")
Tracker:AddItems("items/dexsanity_sent.json")

-- Logic
ScriptHost:LoadScript("scripts/utils.lua")
ScriptHost:LoadScript("scripts/logic/logic.lua")
ScriptHost:LoadScript("scripts/logic/dexsanity.lua")

-- Maps
Tracker:AddMaps("maps/overworld.json")
Tracker:AddMaps("maps/goal_ghetsis.json")
Tracker:AddMaps("maps/pokedex.json")
Tracker:AddMaps("maps/maps.json")
Tracker:AddMaps("maps/mistralton_city_b.json")
Tracker:AddMaps("maps/opelucid_city_b.json")
Tracker:AddMaps("maps/nscastlethroneroom_b.json")

-- Locations
Tracker:AddLocations("locations/goal_locations.json")
Tracker:AddLocations("locations/locations.json")
Tracker:AddLocations("locations/access.json")
Tracker:AddLocations("locations/pokedex.json")
Tracker:AddLocations("locations/dexsanity.json")
Tracker:AddLocations("locations/submaps.json")

-- Layout
Tracker:AddLayouts("layouts/pokedex.json")
Tracker:AddLayouts("layouts/items/items.json")
Tracker:AddLayouts("layouts/items/evo_enc_items.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/settings.json")
Tracker:AddLayouts("layouts/events/events.json")
Tracker:AddLayouts("layouts/tabs_single.json")
Tracker:AddLayouts("layouts/submaps.json")
Tracker:AddLayouts("layouts/dexsearch.json")
Tracker:AddLayouts("layouts/dexsearch/dexsearch_form.json")
Tracker:AddLayouts("layouts/quick_settings.json")
Tracker:AddLayouts("layouts/seasons.json")

-- AutoTracking for Poptracker
ScriptHost:LoadScript("scripts/autotracking.lua")

-- Watches
ScriptHost:AddWatchForCode("goal", "goal_ghetsis", toggle_goal)
ScriptHost:AddWatchForCode("goal2", "goal_champion", toggle_goal)
ScriptHost:AddWatchForCode("goal3", "goal_cynthia", toggle_goal)
ScriptHost:AddWatchForCode("goal4", "goal_cobalion", toggle_goal)
ScriptHost:AddWatchForCode("goal5", "goal_tmhm_hunt", toggle_goal)
ScriptHost:AddWatchForCode("goal6", "goal_seven_sages_hunt", toggle_goal)
ScriptHost:AddWatchForCode("goal7", "goal_legendary_hunt", toggle_goal)
ScriptHost:AddWatchForCode("game_version3", "game_version", toggle_goal)
ScriptHost:AddWatchForCode("game_version", "game_version", toggle_versionmaps)
ScriptHost:AddWatchForCode("splitmap", "splitmap", toggle_splitmap)
ScriptHost:AddWatchForCode("season_control_randomized", "season_control_randomized", toggle_seasongrid)
ScriptHost:AddWatchForCode("dexsanity", "dexsanity", toggle_keyitemgrid)
ScriptHost:AddWatchForCode("game_version2", "game_version", toggle_keyitemgrid)
ScriptHost:AddWatchForCode("add_ssticket", "add_ssticket", toggle_keyitemgrid)
ScriptHost:AddWatchForCode("add_pass", "add_pass", toggle_keyitemgrid)
ScriptHost:AddWatchForCode("add_rocksmash", "add_rocksmash", toggle_keyitemgrid)
ScriptHost:AddWatchForCode("encounter_tracking", "encounter_tracking", updatePokemon)
ScriptHost:AddWatchForCode("search_active", "search_active", searchMon)
ScriptHost:AddWatchForCode("search_reset_complete", "search_reset_complete", searchReset)
ScriptHost:AddWatchForCode("dexsearch_digit1", "dexsearch_digit1", toggle_dexsearch_form)
ScriptHost:AddWatchForCode("dexsearch_digit2", "dexsearch_digit2", toggle_dexsearch_form)
ScriptHost:AddWatchForCode("dexsearch_digit3", "dexsearch_digit3", toggle_dexsearch_form)
ScriptHost:AddWatchForCode("hint_tracking", "hint_tracking", toggleHints)
ScriptHost:AddWatchForCode("slotdigit_1", "slotdigit_1", updateSlot)
ScriptHost:AddWatchForCode("slotdigit_2", "slotdigit_2", updateSlot)
ScriptHost:AddWatchForCode("slotdigit_3", "slotdigit_3", updateSlot)

-- Event Location Syncs
for _, code in ipairs(FLAG_EVENT_CODES) do
    ScriptHost:AddWatchForCode(code, code, syncHostedFromBase)
    ScriptHost:AddWatchForCode(code.."_hosted", code.."_hosted", syncBaseFromHosted)
end

-- Maual Event Syncs
for _, code in ipairs(MANUAL_EVENT_CODES) do
    ScriptHost:AddWatchForCode(code, code, syncHostedFromBase)
    ScriptHost:AddWatchForCode(code.."_hosted", code.."_hosted", syncBaseFromHosted)
end