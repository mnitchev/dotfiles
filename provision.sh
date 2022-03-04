#!/bin/bash
set -euo pipefail

readonly USAGE="Usage: provision.sh [-l | -c <command_name>]"

main() {
  if [[ $EUID -ne 0 ]]; then
    echo "Script must be run as root."
    exit 1
  fi

  while getopts ":lch" opt; do
    case ${opt} in
      l)
        declare -F | awk '{ print $3 }' | grep -v main
        exit 0
        ;;
      c)
        shift $((OPTIND - 1))
        for command in $@; do
          $command
        done
        exit $?
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

  setup_locale
  install_packages
  install_snaps
  install_openvpn
  install_kubectl
  install_nodejs
  install_nvim
  install_npm_packages
  install_golang
  install_misc_tools
  install_delta
  install_github_cli
  install_helm3
}

setup_locale() {
  echo ">>> Setting up the en_US locale"
  apt-get -y install locales
  locale-gen en_US.UTF-8
  update-locale LANG=en_US.UTF-8
}

install_packages() {
  echo ">>> Installing the APT packages"
  apt-get update
  apt-get -y install \
    apt-transport-https \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    cmake \
    cowsay \
    curl \
    direnv \
    fd-find \
    fortune \
    fzf \
    g++ \
    git \
    gnome-tweaks \
    iputils-ping \
    jq \
    lastpass-cli \
    libdevmapper-dev \
    libevent-dev \
    libncurses5-dev \
    libssl-dev \
    libtool \
    libtool-bin \
    net-tools \
    ntp \
    pkg-config \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    ripgrep \
    slack \
    software-properties-common \
    stow \
    tmux \
    unzip \
    wget \
    xsel \
    zsh
}

install_openvpn() {
  curl -fsSL https://swupdate.openvpn.net/repos/openvpn-repo-pkg-key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/openvpn-repo-pkg-keyring.gpg
  curl -fsSL https://swupdate.openvpn.net/community/openvpn3/repos/openvpn3-impish.list >/etc/apt/sources.list.d/openvpn3.list
  apt update
  apt-get install -y openvpn3
}

install_snaps() {
  echo ">>> Installing the Snap packages"
  snap install shfmt
  snap install lolcat
  snap install shellcheck --edge
}

install_kubectl() {
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  rm -f kubectl
}

install_golang() {
  echo ">>> Installing Golang"
  rm -rf /usr/local/go
  mkdir -p /usr/local/go
  curl -sL "https://dl.google.com/go/go1.17.5.linux-amd64.tar.gz" | tar xz -C "/usr/local"
}

install_nodejs() {
  echo ">>> Installing NodeJS"
  curl -sL https://deb.nodesource.com/setup_14.x | bash -
  apt-get -y install nodejs
}

install_nvim() {
  echo ">>> Installing NeoVim"
  if grep -q '^deb http://ppa.launchpad.net/neovim-ppa/stable/ubuntu' /etc/apt/sources.list.d/*.list; then
    add-apt-repository --remove ppa:neovim-ppa/stable -y
    apt-get remove -y neovim
  fi

  url="$(curl -s https://api.github.com/repos/neovim/neovim/releases/tags/v0.6.1 | jq -r '.assets[] | select(.name == "nvim.appimage") | .browser_download_url')"

  curl -sL "$url" --output /tmp/nvim
  chmod +x /tmp/nvim
  mv /tmp/nvim /usr/bin/
}

install_misc_tools() {
  echo ">>> Installing git-duet"
  curl -sL "https://github.com/git-duet/git-duet/releases/download/0.7.0/linux_amd64.tar.gz" | tar xvz -C /usr/bin

  echo ">>> Installing terraform"
  curl -sL "https://releases.hashicorp.com/terraform/0.15.4/terraform_0.15.4_linux_amd64.zip" -o /tmp/terraform.zip
  unzip -ou /tmp/terraform.zip -d /usr/bin
  rm /tmp/terraform.zip

  echo ">>> Installing yq"
  curl -sLo yq https://github.com/mikefarah/yq/releases/download/v4.6.2/yq_linux_amd64 && install yq /usr/local/bin/ && rm -f yq
}

install_npm_packages() {
  echo ">>> Installing npm packages"
  npm install -g bash-language-server tldr
}

install_delta() {
  echo ">>> Installing delta"
  set -x
  curl -sL https://github.com/dandavison/delta/releases/download/0.1.1/delta-0.1.1-x86_64-unknown-linux-musl.tar.gz -o /tmp/delta.tar.gz
  tar xzvf /tmp/delta.tar.gz
  mv delta-0.1.1-x86_64-unknown-linux-musl/delta /usr/bin
  rm -fr delta-0.1.1-x86_64-unknown-linux-musl /tmp/delta.tar.gz
  set +x
}

install_github_cli() {
  echo ">>> Installing Github CLI"
  apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
  apt-add-repository https://cli.github.com/packages
  apt update
  apt install gh
}

install_helm3() {
  echo ">>> Installing Helm3"
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 &&
    chmod 700 get_helm.sh &&
    ./get_helm.sh &&
    rm -f ./get_helm.sh
}

main $@
