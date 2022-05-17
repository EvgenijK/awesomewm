local awful = require('awful')

return {
    names = {
        { "browser", "phpStorm", "VM", "4", "5", "6" },
        { "term", "sublime", "telegram", "discord", "5" }
    },
    layout = {
        { awful.layout.layouts[10], awful.layout.layouts[10], awful.layout.layouts[10], awful.layout.layouts[10], awful.layout.layouts[10], awful.layout.layouts[10] },
        { awful.layout.layouts[10], awful.layout.layouts[10], awful.layout.layouts[10], awful.layout.layouts[10], awful.layout.layouts[10] }
    }
}
