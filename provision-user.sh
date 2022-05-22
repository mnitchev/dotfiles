#!/bin/bash
set -euo pipefail

readonly USAGE="Usage: provision.sh [-l | -c <command_name>]"

main() {
  while getopts ":lch" opt; do
    case ${opt} in
      l)
        declare -F | awk '{ print $3 }' | grep -vE "(main|go_install|git_clone)"
        exit 0
        ;;
      c)
        shift $((OPTIND - 1))
        for command in $@; do
          $command
        done
        exit 0
        ;;
      h)
        echo $USAGE
        exit 0
        ;;
      \?)
        echo "Invalid option: $OPTARG" 1>&2
        echo $USAGE
        exit 1
        ;;
    esac
  done
  shift $((OPTIND - 1))
  echo ">>> Installing everything..."
  mkdir_home_user_bin
  install_gotools
  install_docker
  install_ohmyzsh
  install_vim_plug
  install_nvim_extensions
  install_cred_alert
  configure_dotfiles
  install_vim_plugins
  install_misc_tools
  install_pure_zsh_theme
  install_tmux_plugin_manager
  install_zsh_autosuggestions
  install_krew
  install_kubectl_plugins
  install_kitty
  switch_to_zsh
}

mkdir_home_user_bin() {
  mkdir -p $HOME/bin
}

install_cred_alert() {
  os_name=$(uname | awk '{print tolower($1)}')
  curl -o cred-alert-cli \
    https://github.com/pivotal-cf/cred-alert/releases/download/2021-06-09-20-24-53/cred-alert-cli_linux
  chmod 755 cred-alert-cli
  mv cred-alert-cli "$HOME/bin/"
}

install_docker() {
  echo ">>> Installing Docker"
  if command -v docker; then
    sudo apt upgrade docker-ce docker-ce-cli docker-ce-rootless-extras -y
  else
    curl -fsSL get.docker.com | sudo sh
    sudo usermod -aG docker $USER
  fi
}

install_gotools() {
  echo ">>> Installing golangci-lint"
  curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$HOME/go/bin/" v1.44.0

  echo ">>> Installing gopls"
  go_install golang.org/x/tools/gopls

  echo ">>> Installing fillstruct"
  go_install github.com/davidrjenni/reftools/cmd/fillstruct

}

install_ohmyzsh() {
  echo ">>> Installing Oh My Zsh"
  [ ! -d "$HOME/.oh-my-zsh" ] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  # Delete default .zshrc to avoid stow conflicts
  rm -f "$HOME/.zshrc"
}

install_tmux_plugin_manager() {
  echo ">>> Installing TPM"
  git_clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

install_zsh_autosuggestions() {
  echo ">>> Installing zsh-autosuggestions"
  git_clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

install_vim_plug() {
  echo ">>> Installing vim-plug"
  curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install_nvim_extensions() {
  echo ">>> Installing the NeoVim extensions"
  sudo npm install -g neovim
  pip3 install --upgrade pip
  pip3 install --upgrade neovim
}

git_clone() {
  local url path name branch
  url=$1
  path=${2:-""}
  branch=${3:-""}

  if [ -z "$path" ]; then
    name=$(echo "$url" | sed 's/\.git//g' | cut -d / -f 2)
    path="$HOME/workspace/$name"
  fi

  if [ -d "$path" ]; then
    echo "Repository $path already exists. Skipping git clone..."
    return
  fi

  git clone "$url" "$path"

  if [ -f "$path/.gitmodules" ]; then
    git -C "$path" submodule update --init --recursive
  fi

  if [ -n "$branch" ]; then
    git -C "$path" switch "$branch"
  fi
}

configure_dotfiles() {
  echo ">>> Installing dotfiles"

  git_clone "git@github.com:mnitchev/dotfiles.git"

  pushd "$HOME/workspace/dotfiles"
  {
    git checkout master
    git pull -r
    ./install.sh

    export GIT_DUET_CO_AUTHORED_BY=1
    export GIT_DUET_GLOBAL=true
    git solo mn # initialise git-duet
    git init    # install git-duet hooks on dotfiles
  }
  popd
}

install_vim_plugins() {
  echo ">>> Installing the NeoVim plugins"
  # If we run the command below with init.vim (the default) it will fail because some lua files
  # cannot be loaded. This is so because plug hasn't yet installed the corresponding plugins that
  # are bringing those files (dependency loop). In order to untie the loop we do plug install/update
  # with just the plug part of the config. Later when you run nvim it will laod and install all remaining
  # stuff without you having to run :PlugInstall.
  nvim -u "$HOME/.config/nvim/plug.vim" --headless +PlugClean +PlugInstall +PlugUpdate +UpdateRemotePlugins +qall
}

install_misc_tools() {
  echo ">>> Installing Ginkgo"
  go_install "github.com/onsi/ginkgo/ginkgo"

  echo ">>> Installing k9s (v0.25.8)"
  curl -L https://github.com/derailed/k9s/releases/download/v0.25.8/k9s_Linux_x86_64.tar.gz | tar xvzf - -C "$HOME/bin" k9s

  echo ">>> Installing kind (v0.11.1)"
  curl -L https://github.com/kubernetes-sigs/kind/releases/download/v0.11.1/kind-linux-amd64 -o "$HOME/bin/kind"
  chmod +x "$HOME/bin/kind"
}

go_install() {
  local package=$1
  local version=${2:-latest}

  /usr/local/go/bin/go install $package@$version
}

install_pure_zsh_theme() {
  echo ">>> Installing the pure prompt"
  mkdir -p "$HOME/.zsh"
  git_clone "https://github.com/sindresorhus/pure.git" "$HOME/.zsh/pure"
  pushd "$HOME/.zsh/pure"
  {
    # pure have switched from `master` to `main` for their main branch
    # TODO remove this once everyone has been migrated
    if git show-ref --quiet refs/heads/master; then
      git branch -m master main
      git branch --set-upstream-to=origin/main
    fi
    git pull -r
  }
  popd
}

install_kitty() {
  local latest_release release_number
  latest_release="$(curl -s https://api.github.com/repos/kovidgoyal/kitty/releases/latest | jq -r '.tag_name')"
  release_number="$(echo $latest_release | cut -c 2-)"

  echo ">>> Installing kitty ($latest_release)"

  mkdir -p "$HOME/workspace/kitty"
  curl -L "https://github.com/kovidgoyal/kitty/releases/download/${latest_release}/kitty-${release_number}-x86_64.txz" | tar -xJ -C "$HOME/workspace/kitty"
  if ! [[ -f "$HOME/bin/kitty" ]]; then
    ln -s "$HOME/workspace/kitty/bin/kitty" "$HOME/bin/kitty"
  fi

  local kitty_desktop="~/.local/share/applications/kitty.desktop"
  if ! [[ -f "$kitty_desktop" ]]; then
    ln -s "$SCRIPT_DIR/kitty/kitty.desktop" "$kitty_desktop"
  fi

  cp $HOME/workspace/kitty/share/applications/kitty-open.desktop ~/.local/share/applications/
}

install_krew() {
  set -x
  cd "$(mktemp -d)"
  OS="$(uname | tr '[:upper:]' '[:lower:]')"
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
  KREW="krew-${OS}_${ARCH}"

  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz"
  tar zxvf "${KREW}.tar.gz"
  ./"${KREW}" install krew
}

install_kubectl_plugins() {
  kubectl krew install gs
}

switch_to_zsh() {
  echo ">>> Setting Zsh as the default shell"
  sudo chsh -s /bin/zsh "$(whoami)"
}

main $@
