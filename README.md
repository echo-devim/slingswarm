# Slingswarm

Slingswarm is the GTK+3 version of Slingscold, i.e. a lightweight application launcher similar to Launchpad in Mac OS X.

This project is a fork of Slingscold:

  * http://sourceforge.net/projects/slingscold/

## Compilation

Enter inside the **build** folder and execute `cmake ..` and after `make`.

If you get the following error message:

```error: Package 'unique-3.0' not found in specified Vala API directories or GObject-Introspection GIR directories```

Move the `unique-3.0.vapi` and `unique-3.0.deps` files from the local **fix** folder to **/usr/share/vala-*your_version*/vapi**

## Post Install

Once installed set shortcut key to access Slingswarm.

  * System -> Preferences -> Hardware -> Keyboard Shortcuts > click Add
  * Name: Slingswarm
  * Command: slingswarm-launcher

Now assign it a shortcut key, such as CTRL+SPACE.
