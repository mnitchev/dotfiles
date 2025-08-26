#!/bin/bash
set -euo pipefail

readonly USAGE="Usage: provision.sh [-l | -c <command_name>]"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

main() {
  # if [[ $EUID -ne 0 ]]; then
  #   echo "Script must be run as root."
  #   exit 1
  # fi

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

  install_packages
  setup_locale
  install_misc_tools
  install_gcloud
}


add_sshd_config() {
  echo "StreamLocalBindUnlink yes" >/etc/ssh/sshd_config.d/streamlocalbindunlink.conf
  systemctl restart ssh.service
}

setup_locale() {
  echo ">>> Setting up the en_US locale"
  apt-get -y install locales
  locale-gen en_US.UTF-8
  update-locale LANG=en_US.UTF-8
}

install_packages() {
  echo ">>> Installing brew packages"
  brew install \
    cmake
    # curl \
    # delta \
    # dive \
    # fd \
    # fzf \
    # gh \
    # git \
    # golang \
    # helm \
    # jq \
    # kubectl \
    # node \
    # nvim \
    # openssh \
    # python3 \
    # ripgrep \
    # stow \
    # tmux \
    # unzip \
    # wget \
    # yq \
    # zsh

   brew install --cask ngrok
}

install_openvpn() {
  mkdir -p /etc/apt/keyrings    ### This might not exist in all distributions
  curl -sSfL https://packages.openvpn.net/packages-repo.gpg >/etc/apt/keyrings/openvpn.asc
  echo "deb [signed-by=/etc/apt/keyrings/openvpn.asc] https://packages.openvpn.net/openvpn3/debian noble main" >>/etc/apt/sources.list.d/openvpn3.list
  echo "deb [signed-by=/etc/apt/keyrings/openvpn.asc] https://packages.openvpn.net/openvpn3/debian bookworm main" >>/etc/apt/sources.list.d/openvpn3.list
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
  curl -sL "https://dl.google.com/go/go1.24.4.linux-amd64.tar.gz" | tar xz -C "/usr/local"
}

install_nodejs() {
  echo ">>> Installing NodeJS"
  curl -sL https://deb.nodesource.com/setup_20.x | bash -
  apt-get -y install nodejs
}

install_nvim() {
  echo ">>> Installing NeoVim"
  local url latest_release
  latest_release="$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | jq -r '.tag_name')"
  url="$(curl -s https://api.github.com/repos/neovim/neovim/releases/tags/${latest_release} | jq -r '.assets[] | select(.name == "nvim.appimage") | .browser_download_url')"

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
}

install_npm_packages() {
  echo ">>> Installing npm packages"
  npm install -g bash-language-server tldr
}

install_delta() {
  echo ">>> Installing delta"
  set -x
  curl -sL https://github.com/dandavison/delta/releases/download/0.12.1/git-delta_0.12.1_amd64.deb -o /tmp/delta.deb
  dpkg -i /tmp/delta.deb
  rm -f /tmp/delta.deb
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

install_layout() {
  cp $SCRIPT_DIR/xkb/xy /usr/share/X11/xkb/symbols/xy
  cp $SCRIPT_DIR/xkb/bx /usr/share/X11/xkb/symbols/bx

  if ! grep -q '<name>xy</name>' /usr/share/X11/xkb/rules/evdev.xml; then
    sed -i '/<layoutList>/r xkb/layout.xml' /usr/share/X11/xkb/rules/evdev.xml
    dpkg-reconfigure xkb-data
  fi
  gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'xy'), ('xkb', 'bx')]"
}

install_vault() {
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  sudo apt-get update && sudo apt-get install vault
}

install_gcloud() {
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
  sudo apt-get update && sudo apt-get install -y  google-cloud-cli
}

install_dive() {
  wget https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.deb
  apt install ./dive_0.9.2_linux_amd64.deb
  rm ./dive_0.9.2_linux_amd64.deb
}

main $@
