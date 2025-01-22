# Requirements

- awesome 4.3
- menu 
  - freedesktop (https://github.com/lcpz/awesome-freedesktop), also in AUR
- XDG Autostart
  - xorg-xrdb
  - dex

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

# Problems

## Chrome not using gnome keyring

Create ~/.config/chromium-flags.conf
with: 
```
--password-store=gnome-libsecret
```
