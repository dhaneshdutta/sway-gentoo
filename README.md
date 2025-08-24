## this is what i use as my daily driver :)
welp update/use as you like, this is configured for gentoo (btw)

here's what it looks like?
![preview](assets/desktop.png)

## replicating

### install the nessecary packages

```bash
doas emerge -av grim slurp foot sway swaybg swaylock swayidle rofi-wayland nwg-look pavucontrol nerd-fonts MangoHud cmus cava btop qt6ct neovim
```

### copying

just copy them to your .config and /usr/local/bin and also in /etc for some "the finals" fix

```bash
cp -r sway/ cmus/ foot/ nwg-look/ qt6ct/ rofi/ gtk-3.0/ MangoHud/ nvim user-dirs.dirs ~/.config

cp -r etc/* /etc/
```
