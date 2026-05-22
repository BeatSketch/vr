# BeatSketch

## Installation
Our installation instructions can be found on our [website](https://beatsketch.github.io) or our [meta repo](https://github.com/BeatSketch/BeatSketch)


## Contributing
**All code (so far) proudly human-written.**
*(Codex commit was an accident from a member of the team and doesn't include code)*

If you can't code and still want to help out, [uploading BSOR files](https://polybox.ethz.ch/index.php/s/RbRFRgc7WnmotAg) is an easy way.

### Setting up
Download and install (optional) [LÖVR](https://lovr.org).

Then, clone the [launcher repo](https://github.com/BeatSketch/launcher). To run it, simply open the launcher.

### Running standalone
To run the VR application standalone, follow [this guide](https://lovr.org/docs/Getting_Started#running-a-project)

If you are using Linux with a Wayland Compositor, use [gamescope](https://github.com/ValveSoftware/gamescope) to run it
`gamescope lovr main.lua`

### Hot reloading
To get live-updates, use [lodr](https://github.com/mcclure/lodr).



### Getting type hints from Lua Language Server
- For Neovim, see my configs [here](https://git.janishutz.com/janishutz/nvim/src/branch/main/nvim/lua/plugins/lsp/ls/luals.lua)
- For VSCode, see [here](https://lovr.org/docs/dev/VS_Code_Setup)


## Other remarks
Commits and pull requests should follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) standard, Version 1.0.0.



## Attribution
Map format explanations from [BSMG Wiki](https://bsmg.wiki/mapping/map-format.html) helped a lot with getting that right quickly
