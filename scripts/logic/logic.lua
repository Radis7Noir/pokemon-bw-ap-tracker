function toggle_goal()
    if has("goal_ghetsis") then
        Tracker:AddMaps("maps/goal_ghetsis.json")
    elseif has("goal_champion") then
        Tracker:AddMaps("maps/goal_champion.json")
	elseif has("goal_cynthia") then
        Tracker:AddMaps("maps/goal_cynthia.json")
	elseif has("goal_cobalion") then
        Tracker:AddMaps("maps/goal_cobalion.json")
	elseif has("goal_tmhm_hunt") then
        Tracker:AddMaps("maps/goal_tmhm_hunt.json")
	elseif has("goal_seven_sages_hunt") then
        Tracker:AddMaps("maps/goal_seven_sages_hunt.json")
	elseif has("goal_legendary_hunt") then
        Tracker:AddMaps("maps/goal_legendary_hunt.json")
	elseif has("goal_pokemon_master") then
        Tracker:AddMaps("maps/goal_pokemon_master.json")
	end
end

function flash()
    if has("require_flash_false") then
        return AccessibilityLevel.Normal
    else
        return has("tm70flash") and AccessibilityLevel.Normal or AccessibilityLevel.SequenceBreak
    end
end

function hidden()
    if has("require_dowsingmchn_false") then
        return AccessibilityLevel.Normal
    else
        return has("dowsingmchn") and AccessibilityLevel.Normal or AccessibilityLevel.SequenceBreak
    end
end

function season(season)
    local nimbasa = Tracker:FindObjectForCode("@Nimbasa City Access").AccessibilityLevel
    if has("season_control_vanilla") then
        return AccessibilityLevel.SequenceBreak
    elseif has("season_control_changeable") and nimbasa then
        return nimbasa
    elseif has("season_control_randomized") and nimbasa and has(season) then
        return nimbasa
    end
end

function scout()
  return AccessibilityLevel.Inspect
end