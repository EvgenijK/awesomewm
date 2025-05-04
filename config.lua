local awful = require('awful')

return {
    applications = {
        terminal = "xfce4-terminal",
        web_browser = "google-chrome",
        editor_gui = "emacsclient -c -a 'emacs'",
        editor_cmd = "xfce4-terminal -e vim",
        screen_lock = "xfce4-screensaver-command -l",
    },
    tags = {
        names = {
            { "web", "work", "soc", "game", "5", "6" },
        },
        layout = {
            { awful.layout.layouts[2], awful.layout.layouts[2], awful.layout.layouts[2], awful.layout.layouts[2], awful.layout.layouts[2], awful.layout.layouts[2] },
        }
    },
    titlebars = false,
}