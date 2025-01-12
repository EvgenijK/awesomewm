local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local freedesktop = require("freedesktop")

local config = require("config")

local myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", config.applications.terminal .. " -e man awesome" },
   { "edit config", config.applications.editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local mymainmenu = awful.menu({
    items = { 
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", config.applications.terminal }
    }
})

mymainmenu = freedesktop.menu.build {
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", config.applications.terminal },
        -- other triads can be put here
    }
}

return mymainmenu