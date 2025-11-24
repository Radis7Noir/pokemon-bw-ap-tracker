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
Tracker:AddMaps("maps/goal_ghetsis.json")
Tracker:AddMaps("maps/overworld.json")
Tracker:AddMaps("maps/pokedex.json")

-- Locations
Tracker:AddLocations("locations/locations.json")
Tracker:AddLocations("locations/access.json")
Tracker:AddLocations("locations/pokedex.json")
Tracker:AddLocations("locations/dexsanity.json")
Tracker:AddLocations("locations/overworld/encounters.json")

-- Layout
Tracker:AddLayouts("layouts/pokedex.json")
Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/settings.json")
Tracker:AddLayouts("layouts/tabs.json")

-- AutoTracking for Poptracker
ScriptHost:LoadScript("scripts/autotracking.lua")

-- Watches
ScriptHost:AddWatchForCode("goal", "goal", toggle_goal)
ScriptHost:AddWatchForCode("season_control", "season_control", toggle_seasons)
ScriptHost:AddWatchForCode("encounter_tracking", "encounter_tracking", updatePokemon)