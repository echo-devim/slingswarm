# Slingscold

Slingscold is a fork of Slingshot, i.e. a lightweight application launcher similar to Launchpad in Mac OS X.

This project is a fork of Slingscold:

  * http://sourceforge.net/projects/slingscold/

## KNOWN BUGS / TODOS

* Missing background transparency
* Can't scroll with the middle button

## Compilation

Enter inside the **build** folder and execute `cmake ..` and after `make`.

If you get the following error message:

```error: Package 'unique-3.0' not found in specified Vala API directories or GObject-Introspection GIR directories```

Move the `unique-3.0.vapi` and `unique-3.0.deps` files from the local **fix** folder to **/usr/share/vala-*your_version*/vapi**

## Post Install

Once installed set shortcut key to access Slingscold.

  * System -> Preferences -> Hardware -> Keyboard Shortcuts > click Add
  * Name: Slingscold
  * Command: slingscold-launcher

Now assign it a shortcut key, such as CTRL+SPACE.
