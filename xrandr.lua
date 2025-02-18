--- Separating Multiple Monitor functions as a separeted module (taken from awesome wiki: https://awesomewm.org/recipes/xrandr/)

local gtable  = require("gears.table")
local spawn   = require("awful.spawn")
local naughty = require("naughty")

local HOME = os.getenv("HOME")

-- Initial config
local config = {
    icon_path = "",
    layouts_config_path = HOME .. "/.config/awesome/screen_layout_saves.lua",
}

-- Functions declaration
local load_from_config_or_init
local load_layouts_config
local get_active_output_screens
local get_config_for_current_screens
local apply_config
local screen_change_handler

local cycle_choices_and_apply
local save_config

-- Variables
-- Display xrandr notifications from choices
local state = { cid = nil }

local function start_up()
    load_from_config_or_init()
end

load_from_config_or_init = function()
    local available_config = get_config_for_current_screens()
    if available_config then
        apply_config(available_config)
    else
        cycle_choices_and_apply()
    end
end

get_config_for_current_screens = function()
    local output_screens = get_active_output_screens()
    local layouts_configuration = load_layouts_config()

    return layouts_configuration[table.concat(output_screens, " ")]
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

    table.sort(outputs)

    return outputs
end

load_layouts_config = function()
    local layouts_configuration = {}

    Entry = function(a)
        layouts_configuration[a[4]] = a
    end

    dofile(config.layouts_config_path) -- warning: some bad lua code can sneak in here

    return layouts_configuration
end

apply_config = function(available_config)
    --naughty.notify({ preset = naughty.config.presets.critical,
    --                 title = "Screens handling",
    --                 text = available_config[2] })
    spawn(available_config[2], false)
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
        -- Enabled outputs
        for i, o in pairs(choice) do
            cmd = cmd .. " --output " .. o .. " --auto"
            if i > 1 then
                cmd = cmd .. " --right-of " .. choice[i-1]
            end
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

        menu[#menu + 1] = { label, cmd , out , table.concat(out, " ")}
        -- TODO: it seems 3-d parameter "out" not used anymore - need to check it and remove
    end

    return menu
end

local function naughty_destroy_callback(reason)
    if reason == naughty.notificationClosedReason.expired or
            reason == naughty.notificationClosedReason.dismissedByUser then
        local action = state.index and state.menu[state.index - 1][2]
        if action then
            spawn(action, false)
            state.current = state.menu[state.index - 1]
            state.index = nil

            -- save config to file
            --save_config()
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
    local available_config = get_config_for_current_screens()

    if available_config then
        -- if there is an existing config -> overwrite it
        layouts_configuration[available_config[4]] = current_layout
    else
        -- else -> add new entry
        layouts_configuration[current_layout[4]] = current_layout
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

screen_change_handler = function(output, output_state)
    load_from_config_or_init()

    if output_state == "Disconnected" then
        spawn("xrandr --output " .. output .. " --off", false)
    end
end

return {
    xrandr = cycle_choices_and_apply,
    start_up = start_up,
    save_config = save_config,
    screen_change_handler = screen_change_handler,
}