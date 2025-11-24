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

function toggle_seasons()
    if has("season_control_vanilla") then
        Tracker:AddLayouts("layouts/items.json")
    elseif has("season_control_changeable") then
        Tracker:AddLayouts("layouts/items.json")
	elseif has("season_control_randomized") then
        Tracker:AddLayouts("layouts/items_with_seasons.json")
	end
end
