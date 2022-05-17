local wibox = require('wibox')
local awful = require('awful')

local create_clock = function(s)
    s.clock_widget = wibox.widget.textclock()
    s.month_calendar = awful.widget.calendar_popup.month({
        position = 'tr',
        screen = s,
    })

    s.month_calendar:attach(
            s.clock_widget,
            'tr',
            {
                on_pressed = true,
                on_hover = true
            }
    )

    return s.clock_widget
end

return create_clock
