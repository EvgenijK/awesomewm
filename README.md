# Requirements

- awesome 4.3
- menu 
  - freedesktop (https://github.com/lcpz/awesome-freedesktop), also in AUR
- XDG Autostart
  - xorg-xrdb
  - dex
- xrandr  
- playerctl (for media keys control, daemon starting with .desktop file)

# Autostart

This config uses XDG Autostart to start applications.  
You need configure .desktop files in your XDG-autostart folders

For example in:
- /etc/xdg/autostart/
- ~/.config/autostart

If you are switching from some DE(xfce/gnome/etc) you might see that some applications do not autostart.  
This can be due the `OnlyShowIn` parameter in this .desktop files, like `OnlyShowIn=XFCE;`.  
You need to remove this parameter or add you session name in it.  
I use second variant: `OnlyShowIn=XFCE;Awesome;`

I had problems with polkit and keyring because of `OnlyShowIn` parameter.

# Screen lock/screensaver

I'm using `xfce4-screensaver` right now.  
It has a server that need to run from startup.  
It checks idle time and locks the screen.  

You can run `xfce4-screensaver-command --lock` to lock the screen.  
Or `xflock4` if you have it.

# Activate numpad on startup

I'm using 
```
numlockx on
```
in autostart `.desktop` file 

# Problems

## Chrome not using gnome keyring

Create ~/.config/chromium-flags.conf
with: 
```
--password-store=gnome-libsecret
```
