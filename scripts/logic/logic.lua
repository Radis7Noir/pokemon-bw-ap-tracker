function cut()
    return has("free_cut")
    or (has("hm01cut") and has("triobadge"))
end

function surf()
    return has("free_surf")
    or (has("hm03surf") and has("quakebadge"))
end

function strength()
    return has("free_strength")
    or (has("hm04strength") and has("boltbadge"))
end

function waterfall()
    return has("free_waterfall")
    or (has("hm05waterfall") and has("freezebadge"))
end

function dive()
    return has("free_dive")
    or (has("hm06dive") and has("legendbadge"))
end

function can_rock_smash()
	return has("free_rocksmash")
	or (has("tm94rocksmash") and has("basicbadge"))
end

function rock_smash()
    if has("add_rocksmash_false") then
        return AccessibilityLevel.Normal
	else
		return has("free_rocksmash")
		or (has("tm94rocksmash") and has("basicbadge"))
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

function badges_req(count)
    return (badges() >= tonumber(count))
end

function badges_soft_req(count)
    if (badges() >= tonumber(count)) then
        return AccessibilityLevel.Normal
	else
	    return AccessibilityLevel.SequenceBreak
	end
end

function badges()
    return
    Tracker:ProviderCountForCode("triobadge") +
    Tracker:ProviderCountForCode("basicbadge") +
    Tracker:ProviderCountForCode("insectbadge") +
    Tracker:ProviderCountForCode("boltbadge") +
    Tracker:ProviderCountForCode("quakebadge") +
    Tracker:ProviderCountForCode("jetbadge") +
    Tracker:ProviderCountForCode("freezebadge") +
    Tracker:ProviderCountForCode("legendbadge")
end

--function deerling()
--    if not has("caught_585") then
--        return AccessibilityLevel.Inspect
--    end
--
--    local nimbasa = Tracker:FindObjectForCode("@Nimbasa City Access").AccessibilityLevel
--	
--	if has("season_control_randomized") then
--	    return nimbasa and has("spring") and has("summer") and has("autumn") and has("winter")
--	elseif has("season_control_changeable") then
--	    return nimbasa
--	elseif has("season_control_vanilla") and has("encounters_randomized") then
--	    return AccessibilityLevel.Inspect
--	elseif has("season_control_vanilla") and has("encounters_vanilla") then
--	    return AccessibilityLevel.SequenceBreak
--	else
--	    return AccessibilityLevel.Inspect
--	end
--end