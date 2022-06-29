local awful = require('awful')

return {
    names = {
        { "web", "dev", "VM", "4", "5", "6" },
        { "term", "sublime", "telegram", "discord", "5" }
    },
    layout = {
        { awful.layout.layouts[2], awful.layout.layouts[5], awful.layout.layouts[5], awful.layout.layouts[2], awful.layout.layouts[2], awful.layout.layouts[2] },
        { awful.layout.layouts[2], awful.layout.layouts[2], awful.layout.layouts[2], awful.layout.layouts[2], awful.layout.layouts[2] }
    }
}
