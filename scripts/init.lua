Tracker.AllowDeferredLogicUpdate = true

-- Items
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/events.json")
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
Tracker:AddMaps("maps/pokedex.json")
Tracker:AddMaps("maps/maps.json")
Tracker:AddMaps("maps/mistralton_city_b.json")
Tracker:AddMaps("maps/opelucid_city_b.json")
Tracker:AddMaps("maps/nscastlethroneroom_b.json")

-- Locations
Tracker:AddLocations("locations/locations.json")
Tracker:AddLocations("locations/access.json")
Tracker:AddLocations("locations/pokedex.json")
Tracker:AddLocations("locations/dexsanity.json")
Tracker:AddLocations("locations/overworld/locations.json")

-- Layout
Tracker:AddLayouts("layouts/pokedex.json")
Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/settings.json")
Tracker:AddLayouts("layouts/events.json")
Tracker:AddLayouts("layouts/tabs_single.json")
Tracker:AddLayouts("layouts/submaps.json")
Tracker:AddLayouts("layouts/dexsearch.json")
Tracker:AddLayouts("layouts/quick_settings.json")
Tracker:AddLayouts("layouts/seasons.json")

-- AutoTracking for Poptracker
ScriptHost:LoadScript("scripts/autotracking.lua")

-- Watches
ScriptHost:AddWatchForCode("goal", "goal", toggle_goal)
ScriptHost:AddWatchForCode("splitmap", "splitmap", toggle_splitmap)
ScriptHost:AddWatchForCode("season_control_randomized", "season_control_randomized", toggle_itemgrid)
ScriptHost:AddWatchForCode("dexsanity", "dexsanity", toggle_keyitemgrid)
ScriptHost:AddWatchForCode("encounter_tracking", "encounter_tracking", updatePokemon)
ScriptHost:AddWatchForCode("search_active", "search_active", searchMon)