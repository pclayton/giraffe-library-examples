# gtk3-poly

Poly/ML REPL with shell for running GTK code.

This example builds a variant of `poly` called `gtk3-poly` that provides a sub-shell in which the GLib default main context is iterated synchronously with the Poly/ML REPL so that the effect of any GTK functions occurs immediately.

The sub-shell is entered using
```
enterGtkShell ()
```
which ensures GTK is initialized, and is exited by Ctrl+D.  The variant
```
enterGtkShellWithArgs (args, init)
```
passes `args : string list` to GTK to process and `init : string list -> unit` is called on the remaining arguments not processed by GTK.  Arguments are processed only by the first call to `enterGtkShell` or `enterGtkShellWithArgs` in a session.

## Building

This requires [a patched version of Poly/ML](https://github.com/pclayton/polyml/commits/shell-with-caller-get-char/) and Giraffe Library must be configured to use this version when installed.
