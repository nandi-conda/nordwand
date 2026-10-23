# nordwand

[rattler-build](https://rattler.build) recipes for [Nordwand Mono](https://github.com/tywr/Nordwand-Mono), published to the [`nandi-testing`](https://prefix.dev/channels/nandi-testing) channel on prefix.dev.

| Package | Contents |
| --- | --- |
| `font-ttf-nordwand-mono` | The upstream release TTFs |
| `font-ttf-nerdwand-mono` | Nerdwand Mono: the release TTFs patched with the full Nerd Fonts icon set, using upstream's `scripts/nerd_font.py` |

Fonts are installed to `$PREFIX/fonts/`, like conda-forge's `font-ttf-*` packages.

## Install

```sh
pixi global install -c https://prefix.dev/nandi-testing font-ttf-nerdwand-mono
nerdwand-install-fonts            # register the fonts with your desktop
nerdwand-install-fonts --uninstall
```

The `*-install-fonts` helper symlinks the fonts into `~/.local/share/fonts/<family>` and runs `fc-cache` on Linux, and copies them into `~/Library/Fonts` on macOS.

## Building

```sh
sudo apt install fontforge python3-fontforge   # needed for the Nerd Font patch
rattler-build build --recipe-dir recipes -c conda-forge
```

Pushing to `main` builds any package version not already in the channel and uploads it. Uploads use prefix.dev trusted publishing; a `PREFIX_API_KEY` repository secret works as a fallback.

## Updating

Bump `version` in both recipes and the `NordwandMono-TTF.zip` `sha256` (the same value in both).
