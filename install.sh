#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

stow --dir="$SCRIPT_DIR" --target "$HOME" nvim tmux zsh
