--------------------------------------------------------------------------------
-- apply_traits.lua
--
-- Console-command script (run via the TWW3 "arbitrary lua" console mod).
--
-- Applies a list of traits to the currently SELECTED character (default) or to
-- the selected/local faction's leader. This mirrors the behaviour of the "at"
-- (add-trait) command in the Steam Workshop console-command mod.
--
-- Data format: a list of { trait_id, level } pairs.
--   * position [1] = trait key (string, from the character_traits DB table)
--   * position [2] = level (number) -> passed as the "points" argument of
--                    force_add_trait. This is exactly what the console's
--                    "at <trait_key> <points>" command does.
--       - level <= 0 : add the trait with default points (first tier)
--       - level >  0 : add the trait with that many points, which raises
--                      multi-level traits (e.g. prologue_saviour) to that tier.
--------------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1. CONFIG — edit these two things
------------------------------------------------------------------------

-- Where to apply: "character" = selected character, "faction" = faction leader.
local APPLY_TO = "character"

-- The traits to apply: { trait_id, level }
local TRAITS = {
    { "prologue_saviour",              3 },   -- multi-level trait -> raised to level 3
    { "wh_main_trait_authority_high",  0 },   -- single application, first tier
    -- { "another_trait_key",          2 },
}

-- Show the little in-game notification popup when a trait is added?
local SHOW_MESSAGE = true

------------------------------------------------------------------------
-- 2. HELPERS
------------------------------------------------------------------------

local cm = get_cm and get_cm() or cm  -- campaign_manager; some consoles expose get_cm()

-- Returns the currently selected character (or nil).
-- Documented idiom: cm:get_character_by_cqi(cm:get_campaign_ui_manager():get_char_selected_cqi())
local function get_selected_character()
    local ui = cm:get_campaign_ui_manager()
    local cqi = ui and ui:get_char_selected_cqi()
    if cqi and cqi ~= 0 then
        return cm:get_character_by_cqi(cqi)
    end
    return nil
end

-- Returns the local (player) faction's leader character (or nil).
local function get_faction_leader()
    local faction = cm:get_local_faction(true) or cm:get_local_faction()
    if not faction or faction:is_null_interface() then return nil end
    local leader = faction:faction_leader()
    if leader and not leader:is_null_interface() then return leader end
    return nil
end

-- Build the "character lookup string" that force_add_trait expects.
local function lookup_of(character)
    return cm:char_lookup_str(character)
end

------------------------------------------------------------------------
-- 3. CORE — apply one { trait_id, level } entry to a character
------------------------------------------------------------------------

local function apply_trait(character, trait_id, level)
    local lookup = lookup_of(character)

    -- force_add_trait(character_lookup, trait_key, show_message, [points])
    -- Passing points = level is equivalent to the console "at <trait> <points>"
    -- command and raises multi-level traits to the requested tier in one call.
    if level and level > 0 then
        cm:force_add_trait(lookup, trait_id, SHOW_MESSAGE, level)
    else
        cm:force_add_trait(lookup, trait_id, SHOW_MESSAGE)
    end

    out("apply_traits: added '" .. tostring(trait_id) ..
        "' (points " .. tostring(level or 0) .. ") to character cqi " ..
        tostring(character:command_queue_index()))
end

------------------------------------------------------------------------
-- 4. RUN
------------------------------------------------------------------------

local function run()
    local target
    if APPLY_TO == "faction" then
        target = get_faction_leader()
    else
        target = get_selected_character()
    end

    if not target or target:is_null_interface() then
        out("apply_traits: ERROR - no valid target (" .. APPLY_TO ..
            "). Select a character first, or set APPLY_TO = \"faction\".")
        return
    end

    for _, entry in ipairs(TRAITS) do
        local trait_id = entry[1]
        local level    = entry[2] or 0
        if trait_id and trait_id ~= "" then
            apply_trait(target, trait_id, level)
        end
    end

    out("apply_traits: done.")
end

run()
