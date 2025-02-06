--- Separating Multiple Monitor functions as a separeted module (taken from awesome wiki: https://awesomewm.org/recipes/xrandr/)

local gtable  = require("gears.table")
local spawn   = require("awful.spawn")
local naughty = require("naughty")

-- Initial config
local config = {
    icon_path = "",
    layouts_config_path = "/home/svechnik/.config/awesome/screen_layout_saves.lua", -- TODO make path from home directory
}

-- Functions declaration
local load_from_config_or_init
local load_layouts_config
local get_active_output_screens
local find_config_for_current_screens
local apply_config
local is_two_tables_content_equal

local cycle_choices_and_apply
local save_config


local function start_up()
    load_from_config_or_init()
end

load_from_config_or_init = function()
    local available_config, _ = find_config_for_current_screens()
    if available_config then
        apply_config(available_config)
    else
        cycle_choices_and_apply()
    end
end

find_config_for_current_screens = function()
    local available_config

    local output_screens = get_active_output_screens()
    local layouts_configuration = load_layouts_config()
    local index

    for _, layout_configuration in pairs(layouts_configuration) do
        local layouts_configuration_monitors = layout_configuration[3]

        if is_two_tables_content_equal(output_screens, layouts_configuration_monitors) then
            available_config = layout_configuration
            index = _
            break
        end
    end

    return available_config, index
end

get_active_output_screens = function()
    local outputs = {}
    local xrandr = io.popen("xrandr -q --current")

    if xrandr then
        for line in xrandr:lines() do
            local output = line:match("^([%w-]+) connected ")
            if output then
                outputs[#outputs + 1] = output
            end
        end
        xrandr:close()
    end

    return outputs
end

load_layouts_config = function()
    local layouts_configuration = {}
    local count = 1

    Entry = function(a)
        layouts_configuration[count] = a
        count = count + 1
    end

    dofile(config.layouts_config_path) -- warning: some bad lua code can sneak in here

    return layouts_configuration
end

is_two_tables_content_equal = function(table_1, table_2)
    local is_length_equal = (#table_1 ~= #table_2) -- TODO: need to think of comparing table sizes more carefully
    local is_table_2_has_content_of_table_1 = true

    local table_2_as_set = {}

    -- make a set from table_2 to check content in one cycle
    for _, val in pairs(table_2) do
        table_2_as_set[val] = true
    end

    for _, val in pairs(table_1) do
        if not table_2_as_set[val] then
            is_table_2_has_content_of_table_1 = false
            break
        end
    end

    return is_length_equal and is_table_2_has_content_of_table_1
end

apply_config = function(available_config)
    awful.spawn(available_config[2], false)
end

local function arrange(out)
    -- We need to enumerate all permutations of horizontal outputs.

    local choices  = {}
    local previous = { {} }
    for i = 1, #out do
        -- Find all permutation of length `i`: we take the permutation
        -- of length `i-1` and for each of them, we create new
        -- permutations by adding each output at the end of it if it is
        -- not already present.
        local new = {}
        for _, p in pairs(previous) do
            for _, o in pairs(out) do
                if not gtable.hasitem(p, o) then
                    new[#new + 1] = gtable.join(p, {o})
                end
            end
        end

        choices = gtable.join(choices, new)
        previous = new
    end

    -- Here i change the order of permutations so longer ones are first
    local choices_length = #choices
    for i = 1, choices_length do
        if i > choices_length / 2 then
            break
        end

        choices[i], choices[choices_length - i + 1] = choices[choices_length - i + 1], choices[i]
    end

    return choices
end

-- Build available choices
local function menu()
    local menu = {}
    local out = get_active_output_screens()
    local choices = arrange(out)

    for _, choice in pairs(choices) do
        local cmd = "xrandr"
        local monitors = choice
        -- Enabled outputs
        for i, o in pairs(choice) do
            cmd = cmd .. " --output " .. o .. " --auto"
            if i > 1 then
                cmd = cmd .. " --right-of " .. choice[i-1]
            end
            monitors[i] = o
        end
        -- Disabled outputs
        for _, o in pairs(out) do
            if not gtable.hasitem(choice, o) then
                cmd = cmd .. " --output " .. o .. " --off"
            end
        end

        local label = ""
        if #choice == 1 then
            label = 'Only <span weight="bold">' .. choice[1] .. '</span>'
        else
            for i, o in pairs(choice) do
                if i > 1 then label = label .. " + " end
                label = label .. '<span weight="bold">' .. o .. '</span>'
            end
        end

        menu[#menu + 1] = { label, cmd , monitors }
    end

    return menu
end

-- Display xrandr notifications from choices
local state = { cid = nil }

local function naughty_destroy_callback(reason)
    if reason == naughty.notificationClosedReason.expired or
            reason == naughty.notificationClosedReason.dismissedByUser then
        local action = state.index and state.menu[state.index - 1][2]
        if action then
            spawn(action, false)
            state.current = state.menu[state.index - 1]
            state.index = nil

            -- save config to file
            save_config()
        end
    end
end

cycle_choices_and_apply = function()
    -- Build the list of choices
    if not state.index then
        state.menu = menu()
        state.index = 1
    end

    -- Select one and display the appropriate notification
    local label, action
    local next  = state.menu[state.index]
    state.index = state.index + 1

    if not next then
        label = "Keep the current configuration"
        state.index = nil
    else
        label, action = next[1], next[2]
    end
    state.cid = naughty.notify({ text = label,
                                 icon = config.icon_path,
                                 timeout = 4,
                                 screen = mouse.screen,
                                 replaces_id = state.cid,
                                 destroy = naughty_destroy_callback}).id
end

local function serialize (file, o, prefix)
    prefix = prefix or ""
    if type(o) == "number" then
        file:write(o)
    elseif type(o) == "string" then
        file:write(string.format("%q", o))
    elseif type(o) == "table" then
        file:write("{\n")
        for k, v in pairs(o) do
            file:write(prefix .. "[")
            serialize(file, k, prefix .. "    ")
            file:write("] = ")
            serialize(file, v, prefix .. "    ")
            file:write(",\n")
        end
        file:write(prefix .. "}\n")
    else
        error("cannot serialize a " .. type(o))
    end
end

save_config = function()
    -- load config from file
    layouts_configuration = load_layouts_config()
    current_layout = state.current

    -- check if there is existing config for current monitors
    local available_config, index = find_config_for_current_screens()

    if available_config and index then
        -- if there is an existing config -> overwrite it
        layouts_configuration[index] = current_layout
    else
        -- else -> add new entry
        layouts_configuration[#layouts_configuration + 1] = current_layout
    end

    -- write new config in file
    local config_file = io.open(config.layouts_config_path, "w")
    for _, val in pairs(layouts_configuration) do
        config_file:write("Entry")
        serialize(config_file, val, "    ")
        config_file:write("\n")
    end
    io.close(config_file)
end

return {
    xrandr = cycle_choices_and_apply,
    start_up = start_up,
    save_config = save_config,
}