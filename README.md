# Anytype Nix flake

Run [Anytype](https://anytype.io) on NixOS with:

```
nix run github:cmars/anytype-nix
```

# Status

I'm new to packaging AppImage and electron apps on Nix, these might be packaging related. I might run the AppImage on a stateful OS just to make sure it's not just me though...

## Known issues

* Process does not seem to exit when I close the app window. Have to Ctrl-C interrupt the command that launched it. Need to see what happens if installed into XDG desktop env.
* Links do not open in my browser. xdg-open works on the command-line. Might be a dbus thing.

