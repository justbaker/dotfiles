# dotfiles

This is a collection of my dotfiles for zsh, oh-my-zsh, vim, and tmux.

Installing the dotfiles will remove any conflicting .zshrc .vimrc directories.
It will try to remove .zsh and .vim but will fail unless they are symlinks.

## Installation:

With curl:

`sh -c "$(curl -fsSL https://raw.githubusercontent.com/justbaker/dotfiles/master/tools/install.sh)"`

With wget:

`sh -c "$(wget https://raw.githubusercontent.com/justbaker/dotfiles/master/tools/install.sh -o -)"`

## Themes

The provided `vimrc` file contains a list of available vim themes.

Available Themes:
-------------------
- atom
- getafe
- github
- inkpot
- lucario
- muon
