# Slingswarm

Slingswarm is the GTK+3 version of Slingscold, i.e. a lightweight application launcher similar to Launchpad in Mac OS X. It is also Wayland compatible.

This project was originally forked from Slingscold:

  * http://sourceforge.net/projects/slingscold/

## Compilation

Enter inside the **build** folder and execute `cmake ..` and after `make`.

## Post Install

Once installed set shortcut key to access Slingswarm.

  * System -> Preferences -> Hardware -> Keyboard Shortcuts > click Add
  * Name: Slingswarm
  * Command: slingswarm-launcher

Now assign it a shortcut key, such as CTRL+SPACE.

Note: Some themes don't have the 'application-default-icon'. Slingswarm needs to have this icon, so please download it from the [FlatWoken](https://github.com/alecive/FlatWoken) icon pack and execute the following commands:
```
# cp application-default-icon.svg /usr/share/icons/hicolor/scalable/apps/
# gtk-update-icon-cache /usr/share/icons/hicolor
```

## Changelog
1.0
* Removed libunique dependency (for Wayland compatibility)
* Several code improvements and bug fixes
* Ported Slingscold to GTK3
