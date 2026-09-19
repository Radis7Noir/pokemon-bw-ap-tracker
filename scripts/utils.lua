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

    local ignore_keys = {
        encounter_by_method = true,
        dexsanity_pokemon = true,
        ut_compatibility = true,
        trade_data = true,
        seed = true,
    }

    if type(o) == 'table' then
        local tabs = ('\t'):rep(depth)
        local tabs2 = ('\t'):rep(depth + 1)
        local s = '{\n'
        for k, v in pairs(o) do
            local key_str = tostring(k)
            if not ignore_keys[key_str] then
                if type(k) ~= 'number' then
                    k = '"' .. k .. '"'
                end
                s = s .. tabs2 .. '[' .. k .. '] = ' .. dump_table(v, depth + 1) .. ',\n'
            end
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

    if has("add_ssticket_true") then
        suffix = suffix .. "_ticket"
    end

    if has("add_rocksmash_true") or has("add_rocksmash_musharna") then
        suffix = suffix .. "_rocksmash"
    end

    if has("add_pass_true") then
        suffix = suffix .. "_pass"
    end

    Tracker:AddLayouts("layouts/items/items"..suffix..".json")
end

function toggle_goal()
    local suffix = ""
    if has("pokemon_white") then
        suffix = suffix .. "_w"
	end

    if has("goal_champion_on") then
        suffix = suffix .. "_champion"
	end

    if has("goal_cynthia_on") then
        suffix = suffix .. "_cynthia"
	end

    if has("goal_tmhm_hunt_on") then
        suffix = suffix .. "_tmhmhunt"
	end

    if has("goal_seven_sages_hunt_on") then
        suffix = suffix .. "_sevensageshunt"
	end

    if has("goal_legendary_hunt_on") then
        suffix = suffix .. "_legendaryhunt"
	end

	Tracker:AddLayouts("layouts/events/events"..suffix..".json")
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

function getDigits(code1, code2, code3)
    return (Tracker:FindObjectForCode(code1).CurrentStage or 0) * 100
         + (Tracker:FindObjectForCode(code2).CurrentStage or 0) * 10
         + (Tracker:FindObjectForCode(code3).CurrentStage or 0)
end

function syncHostedFromBase(code)
    Tracker:FindObjectForCode(code.."_hosted").Active = Tracker:FindObjectForCode(code).Active
end

function syncBaseFromHosted(code)
    local base = code:gsub("_hosted", "")
    Tracker:FindObjectForCode(base).Active = Tracker:FindObjectForCode(code).Active
end