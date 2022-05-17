local kbdcfg = {}
kbdcfg.cmd = "setxkbmap"
kbdcfg.layout = { { "us", "" }, { "ru", "" } }
kbdcfg.current = 1

kbdcfg.switch = function ()
    kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
    local t = kbdcfg.layout[kbdcfg.current]
    os.execute( kbdcfg.cmd .. " " .. t[1] .. " " .. t[2] )
end

awesome.connect_signal(
        'module::lang_switch:lang_switch',
        function()
            kbdcfg.switch()
        end
)