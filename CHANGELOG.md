# Changelog

## [1.2.0](https://github.com/flaviomilan/dotfiles.omarchy/compare/v1.1.0...v1.2.0) (2026-04-03)


### Features

* complete overlay setup with bash, installer, and improved docs ([#10](https://github.com/flaviomilan/dotfiles.omarchy/issues/10)) ([cb2c3b2](https://github.com/flaviomilan/dotfiles.omarchy/commit/cb2c3b22e80fa176b7296fdcce06f157c5aaced0))
* improve neotest output UX - output panel at bottom, no floating overlay ([7ee2957](https://github.com/flaviomilan/dotfiles.omarchy/commit/7ee29573349bdee969f09b0fe78726a288b063bb))


### Bug Fixes

* add neotest-minitest adapter for Rails Minitest projects ([5b3470e](https://github.com/flaviomilan/dotfiles.omarchy/commit/5b3470eddea68ec5bb6976c4361fac938472524b))
* correct LazyVim extra paths and use official extras ([0f535a6](https://github.com/flaviomilan/dotfiles.omarchy/commit/0f535a62f1a6492876cde2c9f8684511f119203b))
* disable neotest-golang when go not in PATH, use bundle exec rspec, fix vim-rails lazy load ([7e083e3](https://github.com/flaviomilan/dotfiles.omarchy/commit/7e083e3c73deadbc30f3d2670fa9ba72bb4aa5bc))
* move LazyVim extras to lazy.lua spec in correct order ([#7](https://github.com/flaviomilan/dotfiles.omarchy/issues/7)) ([0d0f238](https://github.com/flaviomilan/dotfiles.omarchy/commit/0d0f2385ae221bc0e2620674e71fc020f751e9cc))
* move neotest-minitest cwd patch to autocmds (LazyDone event) ([ed47e49](https://github.com/flaviomilan/dotfiles.omarchy/commit/ed47e495a9eda71b81d6f2b876db26864ce4d200))
* patch neotest-minitest build_spec to use Gemfile root as cwd ([89dcb62](https://github.com/flaviomilan/dotfiles.omarchy/commit/89dcb627d6a7481aef5ad9ddba1df623797ff5fb))
* restore lazy.lua and sync pending features from open PRs ([9971994](https://github.com/flaviomilan/dotfiles.omarchy/commit/9971994a813ce0e3a83f3dc18ff85d3ba1262275))
* set DISABLE_MINITEST_REPORTERS=1 in neotest test_cmd ([688e79a](https://github.com/flaviomilan/dotfiles.omarchy/commit/688e79a63cea4fee35dcc2d614789d00fc7c3480))
* suppress spurious setContext LSP error from rubocop-lsp ([7f76f56](https://github.com/flaviomilan/dotfiles.omarchy/commit/7f76f5699e1fa3053c6a743ea44dafc933974335))
* use bundle exec ruby -Itest for neotest-minitest, not bin/rails test ([2283d3d](https://github.com/flaviomilan/dotfiles.omarchy/commit/2283d3dd72d04bc1f3db546e885038db108879cc))

## [1.1.0](https://github.com/flaviomilan/dotfiles.omarchy/compare/v1.0.0...v1.1.0) (2026-03-22)


### Features

* add personal neovim configuration ([#2](https://github.com/flaviomilan/dotfiles.omarchy/issues/2)) ([7b0cd85](https://github.com/flaviomilan/dotfiles.omarchy/commit/7b0cd8505a867a7b98a9c854df71e8e7be38b8c0))

## 1.0.0 (2026-03-22)


### Features

* initial setup with git config and README ([5193fef](https://github.com/flaviomilan/dotfiles.omarchy/commit/5193fef2e0dad9832432d3f7a34a2b63e2623456))


### Bug Fixes

* resolve CI failures ([cdd170d](https://github.com/flaviomilan/dotfiles.omarchy/commit/cdd170d4652a747b551137b271289c99ab121d84))
