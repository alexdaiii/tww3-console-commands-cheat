--------------------------------------------------------------------------------
-- power_traits.lua  -  lean "base game only" power set (306 traits)
--
-- Base-game traits (wh_main / wh2_main / wh3_main) with beneficial Economy,
-- Survivability, or Army effects. No DLC-locked traits, no personality/flavour
-- filler, no self-debuffs. Run via the console "arbitrary lua" mod.
--------------------------------------------------------------------------------

local APPLY_TO = "character"   -- "character" (selected) or "faction" (leader)
local SHOW_MESSAGE = true

local TRAITS = {
    -- ---- Survivability ----
    { "wh2_main_trait_casualties", 7 },  -- Wades Through Gore
    { "wh2_main_trait_def_name_of_power_co_01_blackstone", 1 },  -- Name of Power: "Blackstone"
    { "wh2_main_trait_def_name_of_power_co_02_wyrmscale", 1 },  -- Name of Power: "Wyrmscale"
    { "wh2_main_trait_def_name_of_power_co_06_soulblaze", 1 },  -- Name of Power: "Soulblaze"
    { "wh2_main_trait_def_name_of_power_co_08_griefbringer", 1 },  -- Name of Power: "Griefbringer"
    { "wh2_main_trait_def_name_of_power_co_10_fatedshield", 1 },  -- Name of Power: "Fatedshield"
    { "wh2_main_trait_def_name_of_power_co_12_hydrablood", 1 },  -- Name of Power: "Hydrablood"
    { "wh2_main_trait_defeated_archaon_the_everchosen", 1 },  -- Doomslayer
    { "wh2_main_trait_defeated_azhag_the_slaughterer", 1 },  -- Greenskinner
    { "wh2_main_trait_defeated_belegar_ironhammer", 1 },  -- Kinghammer
    { "wh2_main_trait_defeated_grimgor_ironhide", 1 },  -- Hidestriker
    { "wh2_main_trait_defeated_isabella_von_carstein", 1 },  -- Cruelty Restrained
    { "wh2_main_trait_defeated_kroq_gar", 1 },  -- Saurussmiter
    { "wh2_main_trait_defeated_morghur_the_shadowgave", 1 },  -- Skullslasher
    { "wh2_main_trait_defeated_orion", 1 },  -- Wildhunter
    { "wh2_main_trait_defeated_prince_sigvald", 1 },  -- Pride Assassin
    { "wh2_main_trait_defeated_throt", 1 },  -- Deep Cleaner
    { "wh2_main_trait_defeated_ungrim_ironfist", 1 },  -- Slayer King Slayer
    { "wh2_main_trait_defeated_vlad_von_carstein", 1 },  -- Undeath Descendant
    { "wh2_main_trait_defeated_wurzzag", 1 },  -- Great Green Killer
    { "wh2_main_trait_fighter", 30 },  -- Dauntless
    { "wh2_main_trait_wounded", 5 },  -- Neurotic
    { "wh3_main_prologue_egotist", 1 },  -- Egotist
    { "wh3_main_prologue_saviour", 3 },  -- Saviour
    { "wh3_main_trait_dilemma_dae_the_princes_mark", 1 },  -- The Prince's Mark
    { "wh3_main_trait_dilemma_kho_ironhide", 1 },  -- Ironhide
    { "wh3_main_trait_dilemma_ogr_tapestry_of_wounds", 1 },  -- Tapestry of Wounds
    { "wh3_main_trait_hef_unique_mellindirei", 1 },  -- Stormy
    { "wh3_main_trait_ice_court_battler", 1 },  -- Battler
    { "wh3_main_trait_ice_court_perfect_vigour", 1 },  -- Perfect Vigour
    { "wh3_main_trait_ice_court_unbreakable", 1 },  -- Unbreakable
    { "wh3_main_trait_ice_training_ice_guard_captain_hero", 1 },  -- {{tr:character_trait_levels_onscreen_name_wh3_main_trait_ice_training_ice_guard_captain}}
    { "wh3_main_trait_ice_training_unbreakable", 1 },  -- {{tr:character_trait_levels_onscreen_name_wh3_main_trait_ice_court_unbreakable}}
    { "wh3_main_trait_ice_training_unbreakable_hero", 1 },  -- {{tr:character_trait_levels_onscreen_name_wh3_main_trait_ice_court_unbreakable}}
    { "wh3_main_trait_ice_training_vanguard", 1 },  -- Vanguard
    { "wh3_main_trait_ice_training_vanguard_hero", 1 },  -- {{tr:character_trait_levels_onscreen_name_wh3_main_trait_ice_training_vanguard}}
    { "wh3_main_trait_slann_second_generation_mazdamundi", 1 },  -- Second Generation
    { "wh_main_trait_all_personality_all_hates_dwarfs", 2 },  -- Hates Dwarfs
    { "wh_main_trait_all_personality_all_hates_greenskins", 2 },  -- Hates Greenskins
    -- ---- Attack ----
    { "wh2_main_trait_agent_actions_against_beastmen", 5 },  -- Hates Beastmen
    { "wh2_main_trait_agent_actions_against_cathay", 5 },  -- Hates Cathay
    { "wh2_main_trait_agent_actions_against_chaos", 5 },  -- Hates Chaos
    { "wh2_main_trait_agent_actions_against_chaos_dwarfs", 5 },  -- Hates Chaos Dwarfs
    { "wh2_main_trait_agent_actions_against_daemons", 5 },  -- Hates Daemons
    { "wh2_main_trait_agent_actions_against_dark_elves", 5 },  -- Hates Dark Elves
    { "wh2_main_trait_agent_actions_against_dwarfs", 5 },  -- Hates Dwarfs
    { "wh2_main_trait_agent_actions_against_greenskins", 5 },  -- Hates Greenskins
    { "wh2_main_trait_agent_actions_against_high_elves", 5 },  -- Hates High Elves
    { "wh2_main_trait_agent_actions_against_humans", 5 },  -- Hates Men
    { "wh2_main_trait_agent_actions_against_khorne", 5 },  -- Hates Khorne
    { "wh2_main_trait_agent_actions_against_kislev", 5 },  -- Hates Kislev
    { "wh2_main_trait_agent_actions_against_lizardmen", 5 },  -- Hates Lizardmen
    { "wh2_main_trait_agent_actions_against_nurgle", 5 },  -- Hates Nurgle
    { "wh2_main_trait_agent_actions_against_ogre_kingdoms", 5 },  -- Hates Ogres
    { "wh2_main_trait_agent_actions_against_skaven", 5 },  -- Hates Skaven
    { "wh2_main_trait_agent_actions_against_slaanesh", 5 },  -- Hates Slaanesh
    { "wh2_main_trait_agent_actions_against_tomb_kings", 5 },  -- Hates Tomb Kings
    { "wh2_main_trait_agent_actions_against_tzeentch", 5 },  -- Hates Tzeentch
    { "wh2_main_trait_agent_actions_against_vampire_coast", 5 },  -- Hates Vampire Coast
    { "wh2_main_trait_agent_actions_against_vampires", 5 },  -- Hates Vampires
    { "wh2_main_trait_agent_actions_against_wood_elves", 5 },  -- Hates Wood Elves
    { "wh2_main_trait_def_assassins_end", 1 },  -- Assassin's End
    { "wh2_main_trait_def_name_of_power_co_03_poisonblade", 1 },  -- Name of Power: "Poisonblade"
    { "wh2_main_trait_def_name_of_power_co_04_headreaper", 1 },  -- Name of Power: "Headreaper"
    { "wh2_main_trait_def_name_of_power_co_05_spiteheart", 1 },  -- Name of Power: "Spiteheart"
    { "wh2_main_trait_def_name_of_power_co_07_bloodscourge", 1 },  -- Name of Power: "Bloodscourge"
    { "wh2_main_trait_def_name_of_power_co_09_the_hand_of_wrath", 1 },  -- Name of Power: "the Hand of Wrath"
    { "wh2_main_trait_def_name_of_power_co_11_drakecleaver", 1 },  -- Name of Power: "Drakecleaver"
    { "wh2_main_trait_defeated_alberic_de_bordeleaux", 1 },  -- Hammer & Anvil
    { "wh2_main_trait_defeated_durthu", 1 },  -- Tree Surgeon
    { "wh2_main_trait_defeated_grombrindal", 1 },  -- Beardhammer
    { "wh2_main_trait_defeated_helmen_ghorst", 1 },  -- Ghorst or Ghost?
    { "wh2_main_trait_defeated_kholek_suneater", 1 },  -- Stormblight
    { "wh2_main_trait_defeated_louen_leoncouer", 1 },  -- Kingslayer
    { "wh2_main_trait_defeated_malagor_the_dark_omen", 1 },  -- Crowreaver
    { "wh2_main_trait_defeated_queen_headtaker", 1 },  -- Verminflail
    { "wh2_main_trait_defeated_sisters_of_twilight", 1 },  -- Twilight Extinguished
    { "wh2_main_trait_skv_badly_mutated", 1 },  -- Badly Mutated
    { "wh2_main_trait_wins", 9 },  -- Legendary
    { "wh3_main_prologue_vengeful", 3 },  -- Vengeful
    { "wh3_main_prologue_warlord", 1 },  -- Warlord
    { "wh3_main_trait_defeated_katarin", 1 },  -- Ice Lode Crusher
    { "wh3_main_trait_defeated_kostaltyn", 1 },  -- Faith-Breaker
    { "wh3_main_trait_ice_court_better_bows_for_bodyguards_hero", 1 },  -- Better Bows
    { "wh3_main_trait_ice_court_better_swords_for_shielders_hero", 1 },  -- Better Swords
    { "wh3_main_trait_ice_court_cavalry_focused_hero", 1 },  -- Cavalry-Focused
    { "wh3_main_trait_ice_court_fighter", 1 },  -- Fighter
    { "wh3_main_trait_ice_court_glacial_blaster", 1 },  -- Glacial Blaster
    { "wh3_main_trait_ice_court_ice_shard_wielder", 1 },  -- Ice Shard Wielder
    { "wh3_main_trait_ice_court_infantry_focused_hero", 1 },  -- Infantry-Focused
    { "wh3_main_trait_ice_court_magical_warrior", 1 },  -- Magical Warrior
    { "wh3_main_trait_ice_court_magical_warrior_hero", 1 },  -- Magical Warrior
    { "wh3_main_trait_ice_court_martial_encouragement_hero", 1 },  -- Martial Encouragement
    { "wh3_main_trait_ice_court_ranger_hero", 1 },  -- Ranger
    { "wh3_main_trait_ice_training_infantry_commander_hero", 1 },  -- {{tr:character_trait_levels_onscreen_name_wh3_main_trait_ice_training_infantry_commander}}
    { "wh3_main_trait_ice_training_magic_2", 1 },  -- {{tr:character_trait_levels_onscreen_name_wh3_main_trait_ice_court_ice_shard_wielder}}
    { "wh3_main_trait_ice_training_magic_2_hero", 1 },  -- {{tr:character_trait_levels_onscreen_name_wh3_main_trait_ice_court_ice_shard_wielder}}
    { "wh3_main_trait_tmb_unique_nebbetthar", 1 },  -- Captain of the Royal Chariot Guard
    { "wh_main_trait_general_personality_vmp_dark_acolyte", 2 },  -- Dark Acolyte
    -- ---- Army ----
    { "wh2_main_trait_agent_action_assassinate", 5 },  -- {{tr:agent_action_assassinate_name}}
    { "wh2_main_trait_agent_action_assault_garrison", 5 },  -- {{tr:agent_action_assault_garrison_name}}
    { "wh2_main_trait_agent_action_assault_unit", 5 },  -- {{tr:agent_action_assault_unit_name}}
    { "wh2_main_trait_agent_action_assault_units", 5 },  -- {{tr:agent_action_assault_units_name}}
    { "wh2_main_trait_agent_action_block_army", 5 },  -- {{tr:agent_action_block_army_name}}
    { "wh2_main_trait_agent_action_damage_building", 5 },  -- {{tr:agent_action_damage_building_name}}
    { "wh2_main_trait_agent_action_damage_walls", 5 },  -- {{tr:agent_action_damage_walls_name}}
    { "wh2_main_trait_agent_action_wound", 5 },  -- {{tr:agent_action_wound_name}}
    { "wh2_main_trait_agent_target_fail", 7 },  -- Golden
    { "wh2_main_trait_agent_target_success", 7 },  -- Doomed
    { "wh2_main_trait_attacking_victory", 18 },  -- Assault Expert
    { "wh2_main_trait_builder", 15 },  -- Master Mason
    { "wh2_main_trait_def_favoured", 1 },  -- Favoured
    { "wh2_main_trait_def_name_of_power_ar_01_lifequencher", 1 },  -- Name of Power: "Lifequencher"
    { "wh2_main_trait_def_name_of_power_ar_02_the_tempest_of_talons", 1 },  -- Name of Power: "the Tempest of Talons"
    { "wh2_main_trait_def_name_of_power_ar_03_shadowdart", 1 },  -- Name of Power: "Shadowdart"
    { "wh2_main_trait_def_name_of_power_ar_04_barbstorm", 1 },  -- Name of Power: "Barbstorm"
    { "wh2_main_trait_def_name_of_power_ar_05_beastbinder", 1 },  -- Name of Power: "Beastbinder"
    { "wh2_main_trait_def_name_of_power_ar_06_fangshield", 1 },  -- Name of Power: "Fangshield"
    { "wh2_main_trait_def_name_of_power_ar_07_wrathbringer", 1 },  -- Name of Power: "Wrathbringer"
    { "wh2_main_trait_def_name_of_power_ar_08_moonshadow", 1 },  -- Name of Power: "Moonshadow"
    { "wh2_main_trait_def_name_of_power_ar_10_the_grey_vanquisher", 1 },  -- Name of Power: "the Grey Vanquisher"
    { "wh2_main_trait_def_name_of_power_ar_11_krakenclaw", 1 },  -- Name of Power: "Krakenclaw"
    { "wh2_main_trait_def_name_of_power_ar_12_grimgaze", 1 },  -- Name of Power: "Grimgaze"
    { "wh2_main_trait_def_name_of_power_ca_01_dreadtongue", 1 },  -- Name of Power: "Dreadtongue"
    { "wh2_main_trait_def_name_of_power_ca_02_darkpath", 1 },  -- Name of Power: "Darkpath"
    { "wh2_main_trait_def_name_of_power_ca_04_the_black_conqueror", 1 },  -- Name of Power: "the Black Conqueror"
    { "wh2_main_trait_def_name_of_power_ca_05_leviathanrage", 1 },  -- Name of Power: "Leviathanrage"
    { "wh2_main_trait_def_name_of_power_ca_08_pathguard", 1 },  -- Name of Power: "Pathguard"
    { "wh2_main_trait_def_name_of_power_ca_09_the_dark_marshall", 1 },  -- Name of Power: "the Dark Marshall"
    { "wh2_main_trait_def_name_of_power_ca_11_gatesmiter", 1 },  -- Name of Power: "Gatesmiter"
    { "wh2_main_trait_def_name_of_power_ca_12_the_tormentor", 1 },  -- Name of Power: "the Tormentor"
    { "wh2_main_trait_defeated_balthasar_gelt", 1 },  -- Metalstorm
    { "wh2_main_trait_defeated_drycha", 1 },  -- Destroyer of Dryads
    { "wh2_main_trait_defeated_heinrich_kemmler", 1 },  -- Lichekiller
    { "wh2_main_trait_defeated_karl_franz", 1 },  -- Reikshammer
    { "wh2_main_trait_defeated_khazrak_one_eye", 1 },  -- Beastscourge
    { "wh2_main_trait_defeated_lord_mazdamundi", 1 },  -- Spawnkiller
    { "wh2_main_trait_defeated_lord_skrolk", 1 },  -- Plaguelash
    { "wh2_main_trait_defeated_malekith", 1 },  -- Immortal Unbeloved
    { "wh2_main_trait_defeated_mannfred_von_carstein", 1 },  -- Moonslaker
    { "wh2_main_trait_defeated_morathi", 1 },  -- Hagbutcher
    { "wh2_main_trait_defeated_skarsnik", 1 },  -- Sneakysmiter
    { "wh2_main_trait_defeated_teclis", 1 },  -- Ruin Unrestrained
    { "wh2_main_trait_defeated_thorgrim_grudgebearer", 1 },  -- Grudgekiller
    { "wh2_main_trait_defeated_tyrion", 1 },  -- Ulthuan Undefended
    { "wh2_main_trait_defeated_volkmar_the_grim", 1 },  -- Grimsbane
    { "wh2_main_trait_defending_victory", 15 },  -- Impenetrable Wall
    { "wh2_main_trait_far_from_capital", 5 },  -- Seasoned Campaigner
    { "wh2_main_trait_lone_wolf", 3 },  -- Lone Wolf
    { "wh2_main_trait_post_battle_execute", 10 },  -- Headsman
    { "wh2_main_trait_razing", 9 },  -- Carnage Incarnate
    { "wh2_main_trait_reinforcing", 5 },  -- Liberator
    { "wh2_main_trait_ruler_personality_tiranoc_chariots", 1 },  -- Chariot Master
    { "wh2_main_trait_sea_legs", 8 },  -- Seafarer
    { "wh2_main_trait_siege_victory", 12 },  -- Adept Besieger
    { "wh2_main_trait_stance_ambushing", 10 },  -- Ambuscader
    { "wh2_main_trait_stance_astromancy", 10 },  -- Uranologist
    { "wh2_main_trait_stance_channeling", 10 },  -- Devout
    { "wh2_main_trait_stance_forced_march", 12 },  -- Supervisor
    { "wh2_main_trait_stance_raiding", 10 },  -- Freebooter
    { "wh2_main_trait_stance_recruiting", 12 },  -- Musterer
    { "wh2_main_trait_stance_stalking", 10 },  -- Hunter
    { "wh2_main_trait_stance_tunneling", 10 },  -- Tunneller
    { "wh2_main_trait_wins_against_beastmen", 5 },  -- Beast Master
    { "wh2_main_trait_wins_against_cathay", 5 },  -- Victory Over Cathay
    { "wh2_main_trait_wins_against_chaos", 5 },  -- Chaos Breaker
    { "wh2_main_trait_wins_against_chaos_dwarfs", 5 },  -- Dawi-Zharr Doom
    { "wh2_main_trait_wins_against_daemons", 5 },  -- Victory Over Daemons
    { "wh2_main_trait_wins_against_dark_elves", 5 },  -- Druchii Destroyer
    { "wh2_main_trait_wins_against_dwarfs", 5 },  -- Dwarfen Dread
    { "wh2_main_trait_wins_against_greenskins", 5 },  -- Orcsbane
    { "wh2_main_trait_wins_against_high_elves", 5 },  -- Asur Annihilator
    { "wh2_main_trait_wins_against_humans", 5 },  -- Scourge of Mankind
    { "wh2_main_trait_wins_against_khorne", 5 },  -- Victory Over Khorne
    { "wh2_main_trait_wins_against_kislev", 5 },  -- Victory Over Kislev
    { "wh2_main_trait_wins_against_lizardmen", 5 },  -- Reptilian Ravager
    { "wh2_main_trait_wins_against_nurgle", 5 },  -- Victory Over Nurgle
    { "wh2_main_trait_wins_against_ogre_kingdoms", 5 },  -- Victory Over the Ogres
    { "wh2_main_trait_wins_against_rogue_armies", 5 },  -- Rogue Hunter
    { "wh2_main_trait_wins_against_skaven", 5 },  -- Rat Catcher
    { "wh2_main_trait_wins_against_slaanesh", 5 },  -- Victory Over Slaanesh
    { "wh2_main_trait_wins_against_tomb_kings", 5 },  -- Tomb Raider
    { "wh2_main_trait_wins_against_tzeentch", 5 },  -- Victory Over Tzeentch
    { "wh2_main_trait_wins_against_vampire_coast", 5 },  -- Pirate Hunter
    { "wh2_main_trait_wins_against_vampires", 5 },  -- Vampire Slayer
    { "wh2_main_trait_wins_against_wood_elves", 5 },  -- Lumberjack
    { "wh2_main_trait_wins_at_sea", 9 },  -- Master & Commander
    { "wh3_main_prologue_chosen", 1 },  -- Ursun's Chosen
    { "wh3_main_prologue_devious", 1 },  -- Devious
    { "wh3_main_prologue_honest", 1 },  -- Honest
    { "wh3_main_prologue_trait_post_battle_execute", 10 },  -- Headsman
    { "wh3_main_trait_ataman_defender", 1 },  -- Defender
    { "wh3_main_trait_ataman_drillmaster", 1 },  -- Drillmaster
    { "wh3_main_trait_ataman_master_builder", 1 },  -- Master Builder
    { "wh3_main_trait_ataman_observant", 1 },  -- Observant
    { "wh3_main_trait_ataman_pragmatic_defender", 1 },  -- Pragmatic Defender
    { "wh3_main_trait_blessed_by_ind_blades", 1 },  -- Blessed by Ind – Blades
    { "wh3_main_trait_bst_unique_kharak_stoneheart", 1 },  -- Two-in-One
    { "wh3_main_trait_caravan_daemon_hunter", 1 },  -- Brave Beyond Reason
    { "wh3_main_trait_corrupted_slaanesh", 20 },  -- Corrupted by Slaanesh
    { "wh3_main_trait_defeated_belakor", 1 },  -- Bel'of'the'Ball
    { "wh3_main_trait_defeated_boris", 1 },  -- Red Dead
    { "wh3_main_trait_defeated_daemon_prince", 1 },  -- Slayer of the God-Slayer
    { "wh3_main_trait_defeated_kairos", 1 },  -- Didn’t See That Coming
    { "wh3_main_trait_defeated_miao_ying", 1 },  -- Very Cold, Still Aloof
    { "wh3_main_trait_defeated_nkari", 1 },  -- Tyrion Owes Me
    { "wh3_main_trait_defeated_skarbrand", 1 },  -- Bloodquencher
    { "wh3_main_trait_defeated_skrag_the_slaughterer", 1 },  -- Maw’s the Pity
    { "wh3_main_trait_defeated_zhao_ming", 1 },  -- Merciless to Ming
    { "wh3_main_trait_dilemma_dae_ruinous_infusion", 1 },  -- Ruinous Infusion
    { "wh3_main_trait_dilemma_kho_brutalised_visage", 1 },  -- Brutalised Visage
    { "wh3_main_trait_dilemma_nur_grandfathers_embrace", 1 },  -- Grandfather's Embrace
    { "wh3_main_trait_dilemma_ogr_full_oguts", 1 },  -- Full o'Guts
    { "wh3_main_trait_dilemma_ogr_stomach_reduction_surgery", 1 },  -- Stomach Reduction Surgery
    { "wh3_main_trait_dilemma_sla_avatar_of_agony", 1 },  -- Avatar of Agony
    { "wh3_main_trait_dilemma_sla_intoxicating_presence", 1 },  -- Intoxicating Presence
    { "wh3_main_trait_dilemma_tze_a_thousand_fingers", 1 },  -- A Thousand Fingers
    { "wh3_main_trait_dilemma_tze_whispering_skull", 1 },  -- Whispering Skull
    { "wh3_main_trait_ice_court_agent_of_brutality", 1 },  -- Agent of Brutality
    { "wh3_main_trait_ice_court_artillerist", 1 },  -- Artillerist
    { "wh3_main_trait_ice_court_better_bows_for_bodyguards", 1 },  -- Better Bows
    { "wh3_main_trait_ice_court_better_swords_for_shielders", 1 },  -- Better Swords
    { "wh3_main_trait_ice_court_blessed_are_the_footsoldiers", 1 },  -- Blessed are the Footsoldiers
    { "wh3_main_trait_ice_court_blessed_cavalry", 1 },  -- Blessed Cavalry
    { "wh3_main_trait_ice_court_builder", 1 },  -- Builder
    { "wh3_main_trait_ice_court_campaigner", 1 },  -- Campaigner
    { "wh3_main_trait_ice_court_cavalry_focused", 1 },  -- Cavalry-Focused
    { "wh3_main_trait_ice_court_eldritch_defender", 1 },  -- Eldritch Defender
    { "wh3_main_trait_ice_court_ice_charioteer", 1 },  -- Ice Charioteer
    { "wh3_main_trait_ice_court_infantry_focused", 1 },  -- Infantry-Focused
    { "wh3_main_trait_ice_court_martial_encouragement", 1 },  -- Martial Encouragement
    { "wh3_main_trait_ice_court_martial_magician", 1 },  -- Martial Magician
    { "wh3_main_trait_ice_court_quiet_warrior", 1 },  -- Quiet Warrior
    { "wh3_main_trait_ice_court_raider", 1 },  -- Raider
    { "wh3_main_trait_ice_court_ranger", 1 },  -- Ranger
    { "wh3_main_trait_ice_training_architect", 1 },  -- Architect
    { "wh3_main_trait_ice_training_architect_hero", 1 },  -- {{tr:character_trait_levels_onscreen_name_wh3_main_trait_ice_training_architect}}
    { "wh3_main_trait_ice_training_economist", 1 },  -- {{tr:character_trait_levels_onscreen_name_wh3_main_trait_ice_court_economist}}
    { "wh3_main_trait_ice_training_economist_hero", 1 },  -- {{tr:character_trait_levels_onscreen_name_wh3_main_trait_ice_court_economist}}
    { "wh3_main_trait_ice_training_ice_guard_captain", 1 },  -- Ice Guard Captain
    { "wh3_main_trait_ice_training_infantry_commander", 1 },  -- Infantry Commander
    { "wh3_main_trait_ice_training_logistician", 1 },  -- Logistician
    { "wh3_main_trait_ice_training_logistician_hero", 1 },  -- {{tr:character_trait_levels_onscreen_name_wh3_main_trait_ice_training_logistician}}
    { "wh3_main_trait_ice_training_magic_1", 1 },  -- {{tr:character_trait_levels_onscreen_name_wh3_main_trait_ice_court_glacial_blaster}}
    { "wh3_main_trait_ice_training_magic_1_hero", 1 },  -- {{tr:character_trait_levels_onscreen_name_wh3_main_trait_ice_court_glacial_blaster}}
    { "wh3_main_trait_ice_training_quartermaster", 1 },  -- Quartermaster
    { "wh3_main_trait_tmb_unique_itzi_bitzi", 1 },  -- Incantation of Xetlipocutzl
    { "wh_main_trait_general_personality_vmp_summon_creatures", 2 },  -- Summon Creatures of the Night
    -- ---- Economy ----
    { "wh2_main_trait_agent_action_hinder_replenishment", 5 },  -- {{tr:agent_action_hinder_replenishment_name}}
    { "wh2_main_trait_agent_action_steal_technology", 5 },  -- {{tr:agent_action_steal_technology_name}}
    { "wh2_main_trait_brutally_honest", 1 },  -- Brutally Honest
    { "wh2_main_trait_def_name_of_power_ca_06_emeraldeye", 1 },  -- Name of Power: "Emeraldeye"
    { "wh2_main_trait_def_name_of_power_ca_07_barbedlash", 1 },  -- Name of Power: "Barbedlash"
    { "wh2_main_trait_def_name_of_power_ca_10_the_dire_overseer", 1 },  -- Name of Power: "the Dire Overseer"
    { "wh2_main_trait_defeated_fay_enchantress", 1 },  -- Witchfinder General
    { "wh2_main_trait_post_battle_ransom", 10 },  -- Kidnapper
    { "wh2_main_trait_public_order", 12 },  -- Authoritarian
    { "wh2_main_trait_sacking", 9 },  -- Spoilator
    { "wh3_main_trait_ataman_a_boon_for_all", 1 },  -- A Boon for All
    { "wh3_main_trait_ataman_bolsterer", 1 },  -- Bolsterer
    { "wh3_main_trait_ataman_favours_cavalry", 1 },  -- Favours Cavalry
    { "wh3_main_trait_ataman_favours_infantry", 1 },  -- Favours Infantry
    { "wh3_main_trait_ataman_fiscally_prudent", 1 },  -- Fiscally Prudent
    { "wh3_main_trait_ataman_frost_maiden_ally", 1 },  -- Frost Maiden Ally
    { "wh3_main_trait_ataman_good_host", 1 },  -- Good Host
    { "wh3_main_trait_ataman_horse_comrade", 1 },  -- Horse Comrade
    { "wh3_main_trait_ataman_ice_court_informer", 1 },  -- Ice Court Informer
    { "wh3_main_trait_ataman_investor", 1 },  -- Investor
    { "wh3_main_trait_ataman_orthodoxy_loyalist", 1 },  -- Orthodoxy Loyalist
    { "wh3_main_trait_ataman_pioneer", 1 },  -- Pioneer
    { "wh3_main_trait_ataman_province_first", 1 },  -- Province First
    { "wh3_main_trait_ataman_recruiter", 1 },  -- Recruiter
    { "wh3_main_trait_ataman_reverent_patriarch", 1 },  -- Reverent Patriarch
    { "wh3_main_trait_ataman_traditionalist", 1 },  -- Traditionalist
    { "wh3_main_trait_defeated_greasus_goldtooth", 1 },  -- Cashing Out
    { "wh3_main_trait_dilemma_cth_selfless_leader", 1 },  -- Selfless Leader
    { "wh3_main_trait_ice_court_artillerist_hero", 1 },  -- Artillerist
    { "wh3_main_trait_ice_court_court_controller", 1 },  -- Court Controller
    { "wh3_main_trait_ice_court_economist", 1 },  -- Economist
    { "wh3_main_trait_ice_court_growth_is_great", 1 },  -- Growth is Great
    { "wh3_main_trait_ice_court_ice_charioteer_hero", 1 },  -- Ice Charioteer
    { "wh3_main_trait_ice_court_ownership_is_theft", 1 },  -- Ownership is Theft
    { "wh3_main_trait_ice_court_sacker", 1 },  -- Sacker
    { "wh3_main_trait_ice_training_quartermaster_hero", 1 },  -- {{tr:character_trait_levels_onscreen_name_wh3_main_trait_ice_training_quartermaster}}
    -- ---- Diplomacy ----
    { "wh2_main_trait_reinforcing_beastmen", 4 },  -- Likes Beastmen
    { "wh2_main_trait_reinforcing_cathay", 4 },  -- Likes Cathay
    { "wh2_main_trait_reinforcing_chaos", 4 },  -- Likes Chaos
    { "wh2_main_trait_reinforcing_chaos_dwarfs", 4 },  -- Likes Chaos Dwarfs
    { "wh2_main_trait_reinforcing_daemons", 4 },  -- Likes Daemons
    { "wh2_main_trait_reinforcing_dark_elves", 4 },  -- Likes Dark Elves
    { "wh2_main_trait_reinforcing_dwarfs", 4 },  -- Likes Dwarfs
    { "wh2_main_trait_reinforcing_greenskins", 4 },  -- Likes Greenskins
    { "wh2_main_trait_reinforcing_high_elves", 4 },  -- Likes High Elves
    { "wh2_main_trait_reinforcing_humans", 4 },  -- Likes Men
    { "wh2_main_trait_reinforcing_khorne", 4 },  -- Likes Khorne
    { "wh2_main_trait_reinforcing_kislev", 4 },  -- Likes Kislev
    { "wh2_main_trait_reinforcing_lizardmen", 4 },  -- Likes Lizardmen
    { "wh2_main_trait_reinforcing_nurgle", 4 },  -- Likes Nurgle
    { "wh2_main_trait_reinforcing_ogre_kingdoms", 4 },  -- Likes Ogre Kingdoms
    { "wh2_main_trait_reinforcing_skaven", 4 },  -- Likes Skaven
    { "wh2_main_trait_reinforcing_slaanesh", 4 },  -- Likes Slaanesh
    { "wh2_main_trait_reinforcing_tomb_kings", 4 },  -- Likes Tomb Kings
    { "wh2_main_trait_reinforcing_tzeentch", 4 },  -- Likes Tzeentch
    { "wh2_main_trait_reinforcing_vampire_coast", 4 },  -- Likes Vampire Coast
    { "wh2_main_trait_reinforcing_vampires", 4 },  -- Likes Vampires
    { "wh2_main_trait_reinforcing_wood_elves", 4 },  -- Likes Wood Elves
}

local cm = get_cm and get_cm() or cm

local function get_selected_character()
    local ui = cm:get_campaign_ui_manager()
    local cqi = ui and ui:get_char_selected_cqi()
    if cqi and cqi ~= 0 then return cm:get_character_by_cqi(cqi) end
    return nil
end

local function get_faction_leader()
    local faction = cm:get_local_faction(true) or cm:get_local_faction()
    if not faction or faction:is_null_interface() then return nil end
    local leader = faction:faction_leader()
    if leader and not leader:is_null_interface() then return leader end
    return nil
end

local function run()
    local target = (APPLY_TO == "faction") and get_faction_leader() or get_selected_character()
    if not target or target:is_null_interface() then
        out("power_traits: ERROR - no valid target (" .. APPLY_TO .. "). Select a character first.")
        return
    end
    local lookup = cm:char_lookup_str(target)
    for _, entry in ipairs(TRAITS) do
        local id, pts = entry[1], entry[2] or 0
        if id and id ~= "" then
            if pts and pts > 0 then
                cm:force_add_trait(lookup, id, SHOW_MESSAGE, pts)
            else
                cm:force_add_trait(lookup, id, SHOW_MESSAGE)
            end
        end
    end
    out("power_traits: done.")
end

run()
