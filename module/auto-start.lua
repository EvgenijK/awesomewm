-- Run all the apps listed in configuration/apps.lua as run_on_start_up only once when awesome start

local awful = require('awful')
local apps = require('configuration.apps')

-- {{{ Autostart applications
function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

for _, app in ipairs(apps.run_on_start_up) do
    run_once(app)
end
