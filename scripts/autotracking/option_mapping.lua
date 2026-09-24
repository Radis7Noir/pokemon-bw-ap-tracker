SLOT_CODES = {
    version = {
        code = "game_version",
        mapping = {
            ["black"] = 0,
            ["white"] = 1,
            ["dynamic"] = 0,
        }
    },
    shuffle_badges = {
        code = "shuffle_badges",
        mapping = {
            ["vanilla"]  = 0,
            ["shuffle"]  = 1,
            ["anything"] = 2,
        }
    },
    season_control = {
        code = "season_control",
        mapping = {
            ["vanilla"]    = 0,
            ["changeable"] = 1,
            ["randomized"] = 2,
        }
    },
    starting_season = {
        code = "starting_season",
        mapping = {
            ["Spring"] = 0,
            ["Summer"] = 1,
            ["Autumn"] = 2,
            ["Winter"] = 3,
        }
    },
    starting_town = {
        code = "starting_town",
        mapping = {
            ["Nuvema Town"]     = 0,
            ["Accumula Town"]   = 1,
            ["Striaton City"]   = 2,
            ["Nacrene City"]    = 3,
            ["Castelia City"]   = 4,
            ["Nimbasa City"]    = 5,
            ["Driftveil City"]  = 6,
            ["Mistralton City"] = 7,
            ["Icirrus City"]    = 8,
            ["Opelucid City"]   = 9,
            ["Lacunosa Town"]   = 10,
            ["Undella Town"]    = 11,
        }
    },
}

LIST_CODES = {
    goal = {
        master = "pokemon_master",
        values = {
            ["ghetsis"]          = "goal_ghetsis",
            ["champion"]         = "goal_champion",
            ["cynthia"]          = "goal_cynthia",
            ["cobalion"]         = "goal_cobalion",
            ["tmhm_hunt"]        = "goal_tmhm_hunt",
            ["seven_sages_hunt"] = "goal_seven_sages_hunt",
            ["legendary_hunt"]   = "goal_legendary_hunt",
        }
    },
    modify_logic = {
        values = {
            ["require flash"]           = "require_flash",
            ["require dowsing machine"] = "require_dowsingmchn",
            ["consider evolutions"]     = "consider_evolutions",
            ["consider static pokemon"] = { "consider_statics", "static_visibility" },
            ["consider trades"]         = { "consider_trades", "trade_visibility" },
        }
    },
    adjust_levels = {
        stages = {
            ["wild by distance"]    = { "adjust_wilds", 1 },
            ["wild by sphere"]      = { "adjust_wilds", 2 },
            ["trainer by distance"] = { "adjust_trainers", 1 },
            ["trainer by sphere"]   = { "adjust_trainers", 2 },
        }
    },
    randomize_wild_pokemon = {
        values = {
            ["randomize"] = "randomize_wild",
        }
    },
    dark_areas = {
        values = {
            ["Striaton Gym"]                = "dark_areas_striaton_gym",
            ["Nacrene Gym"]                 = "dark_areas_nacrene_gym",
            ["Castelia Gym"]                = "dark_areas_castelia_gym",
            ["Nimbasa Gym"]                 = "dark_areas_nimbasa_gym",
            ["Driftveil Gym"]               = "dark_areas_driftveil_gym",
            ["Mistralton Gym"]              = "dark_areas_mistralton_gym",
            ["Icirrus Gym"]                 = "dark_areas_icirrus_gym",
            ["Opelucid Gym"]                = "dark_areas_opelucid_gym",
            ["Dreamyard Basement"]          = "dark_areas_dreamyard_basement",
            ["Wellspring Cave 1F"]          = "dark_areas_wellspring_cave_1f",
            ["Wellspring Cave B1F"]         = "dark_areas_wellspring_cave_b1f",
            ["Pinwheel Forest Inside"]      = "dark_areas_pinwheel_forest",
            ["Relic Castle Pre-Sand Room"]  = "dark_areas_relic_castle_pre",
            ["Relic Castle Post-Sand Room"] = "dark_areas_relic_castle_post",
            ["Cold Storage"]                = "dark_areas_cold_storage",
            ["Mistralton Cave"]             = "dark_areas_mistralton_cave",
            ["Guidance Chamber"]            = "dark_areas_guidance_chamber",
            ["Chargestone Cave"]            = "dark_areas_chargestone_cave",
            ["Celestial Tower"]             = "dark_areas_celestial_tower",
            ["Twist Mountain"]              = "dark_areas_twist_mountain",
            ["Dragonspiral Tower"]          = "dark_areas_dragonspiral_tower",
            ["Challengers Cave"]            = "dark_areas_challengers",
            ["Victory Road"]                = "dark_areas_victory_road",
            ["Giant Chasm"]                 = "dark_areas_giant_chasm",
        }
    },
}

DEFAULT_DARK_AREAS = {
    ["Wellspring Cave B1F"] = true,
    ["Mistralton Cave"]     = true,
    ["Challengers Cave"]    = true,
}
