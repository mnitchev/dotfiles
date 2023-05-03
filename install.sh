#!/bin/bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

main() {
  configure_home "$@"
  install_zsh_theme
  generate_gitconfig
  prepare_coq_nvim
}

generate_gitconfig() {
  if [[ -f "$HOME/.gitconfig" ]]; then
    return
  fi

  cat <<EOF >"$HOME/.gitconfig"
[include]
  path = $HOME/.common-gitconfig
[user]
  name = "Mario Nitchev"
  email = "marionitchev@gmail.com"
[duet "env"]
  git-author-initials = mn
  git-author-name = Mario Nitchev
  git-author-email = marionitchev@gmail.com
EOF
}

configure_home() {
  local bundles action
  bundles=(nvim tmux zsh git-hooks git util kitty)
  action=${1:-"install"}

  stow --dir="$SCRIPT_DIR" --target "$HOME" --delete "${bundles[@]}"
  if [[ "$action" == "clean" ]]; then
    return
  fi
  stow --dir="$SCRIPT_DIR" --target "$HOME" "${bundles[@]}"
}

install_zsh_theme() {
  mkdir -p "$ZSH_CUSTOM/themes"
  local lambda_theme_dir="$ZSH_CUSTOM/themes/lambda-mod-zsh-theme"
  if [[ -d "$lambda_theme_dir" ]]; then
    git --git-dir="${lambda_theme_dir}/.git" --work-tree="$lambda_theme_dir" pull
    return
  fi

  git clone https://github.com/halfo/lambda-mod-zsh-theme $ZSH_CUSTOM/themes/lambda-mod-zsh-theme
}

prepare_coq_nvim() {
  nvim --headless "+COQdeps" "+COQsnips compile" "+qall"
}

main "$@"
