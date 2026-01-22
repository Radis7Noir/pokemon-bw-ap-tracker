function has(item, amount)
    local count = Tracker:ProviderCountForCode(item)
    amount = tonumber(amount)
    if not amount then
        return count > 0
    else
        return count >= amount
    end
end

function dump_table(o, depth)
    if depth == nil then
        depth = 0
    end
    if type(o) == 'table' then
        local tabs = ('\t'):rep(depth)
        local tabs2 = ('\t'):rep(depth + 1)
        local s = '{\n'
        for k, v in pairs(o) do
            local kc = k
            if type(k) ~= 'number' then
                kc = '"' .. k .. '"'
            end
            s = s .. tabs2 .. '[' .. kc .. '] = ' .. dump_table(v, depth + 1) .. ',\n'
        end
        return s .. tabs .. '}'
    else
        return tostring(o)
    end
end

function table_contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function toggle_versionmaps()
    if has("pokemon_black") then
        Tracker:AddMaps("maps/mistralton_city_b.json")
        Tracker:AddMaps("maps/nscastlethroneroom_b.json")
        Tracker:AddMaps("maps/opelucid_city_b.json")
    elseif has("pokemon_white") then
        Tracker:AddMaps("maps/mistralton_city_w.json")
        Tracker:AddMaps("maps/nscastlethroneroom_w.json")
        Tracker:AddMaps("maps/opelucid_city_w.json")
	end
end

function toggle_keyitemgrid()    
    local suffix = ""
    if has("pokemon_white") then
        suffix = suffix .. "_w"
	end
	
    if Tracker:FindObjectForCode("dexsanity").AcquiredCount ~= 0 then
        suffix = suffix .. "_fossils"
        Tracker:FindObjectForCode("location_visibility").CurrentStage = 1
    end
        
    Tracker:AddLayouts("layouts/items"..suffix..".json")
end

function toggle_goal()
    local suffix = ""
    if has("goal_ghetsis") then
        suffix = suffix .. "_ghetsis"
	end
    if has("goal_champion") then
        suffix = suffix .. "_champion"
	end
	if has("goal_cynthia") then
        suffix = suffix .. "_cynthia"
	end
	if has("goal_cobalion") then
        suffix = suffix .. "_cobalion"
	end
	if has("goal_tmhm_hunt") then
        suffix = suffix .. "_tmhm_hunt"
	end
	if has("goal_seven_sages_hunt") then
        suffix = suffix .. "_seven_sages_hunt"
	end
	if has("goal_legendary_hunt") then
        suffix = suffix .. "_legendary_hunt"
	end
	if has("goal_pokemon_master") then
        suffix = suffix .. "_pokemon_master"
	end
    if has("pokemon_white") then
        suffix = suffix .. "_w"
	end
	
    Tracker:AddMaps("maps/goal"..suffix..".json")
	Tracker:AddLayouts("layouts/events"..suffix..".json")
end

function toggle_seasongrid()   
    local suffix = ""
    if has("season_control_randomized") then
        suffix = suffix .. "_seasons"
    end
	
    Tracker:AddLayouts("layouts/tracker"..suffix..".json")
end

function toggle_splitmap()
    if has("splitmap_off") then
        Tracker:AddLayouts("layouts/tabs_single.json")
    elseif has("splitmap_on") then
        Tracker:AddLayouts("layouts/tabs_split.json")
    elseif has("splitmap_reverse") then
        Tracker:AddLayouts("layouts/tabs_reverse.json")
    end
end