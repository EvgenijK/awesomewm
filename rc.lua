-- Plans:
-- не запускать лишние экземпляры приложений при рестарте Awesome
-- блокировка экрана без проблемы с русской раскладкой
-- внешний вид:
--   сменить обои

-- Standard awesome library
--local gears = require("gears")
--local awful = require("awful")
require("awful.autofocus")

-- Layout
require('layout')

-- Mouse bindings
require('configuration.buttons')

--- Configuration
require('configuration.client')
require('signals')
root.keys(require('configuration.keys.global'))

-- Modules (if it's need to process something)
require('module.auto-start')
require('module.lang-switch')
