# Use an official base image (change version as needed)
FROM homebrew/brew:latest

# Prevent interactive prompts during package install
ARG DEBIAN_FRONTEND=noninteractive

# Copy the entire repository into the container
RUN mkdir ./dotfiles

RUN brew install \
    bash-language-server \
    cmake \
    curl \
    delta \
    dive \
    docker \
    fd \
    fzf \
    gh \
    git \
    golang \
    helm \
    jq \
    kubectl \
    node \
    nvim \
    openssh \
    python3 \
    ripgrep \
    stow \
    tmux \
    unzip \
    wget \
    yq \
    zsh
COPY . ./dotfiles
RUN ./dotfiles/provision-user.sh

# Default command (change as needed)
CMD ["/bin/zsh"]
