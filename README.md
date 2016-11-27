# Slingswarm

Slingswarm is the GTK+3 version of Slingscold, i.e. a lightweight application launcher similar to Launchpad in Mac OS X.

This project is a fork of Slingscold:

  * http://sourceforge.net/projects/slingscold/

## Compilation

Enter inside the **build** folder and execute `cmake ..` and after `make`.

## Post Install

Once installed set shortcut key to access Slingswarm.

  * System -> Preferences -> Hardware -> Keyboard Shortcuts > click Add
  * Name: Slingswarm
  * Command: slingswarm-launcher

Now assign it a shortcut key, such as CTRL+SPACE.

## Changelog
1.0
* Removed libunique dependency (Wayland compatibility)
* Several code improvements and bug fixes
* Ported Slingscold to GTK3
