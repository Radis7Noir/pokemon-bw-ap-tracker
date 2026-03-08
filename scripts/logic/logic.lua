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