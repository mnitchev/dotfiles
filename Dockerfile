# Use an official base image (change version as needed)
FROM homebrew/brew:latest

# Prevent interactive prompts during package install
ARG DEBIAN_FRONTEND=noninteractive

# Copy the entire repository into the container
RUN mkdir ./dotfiles
COPY . ./dotfiles

RUN ./dotfiles/provision.sh -c install_packages
RUN ./dotfiles/provision.sh -c setup_locale
RUN ./dotfiles/provision.sh -c install_gcloud
# If 'provision-user.sh' must be run as a regular user, do that using 'su' or 'sudo -u'.
# Otherwise, if it’s okay to run as root, you can just do:
RUN ./dotfiles/provision-user.sh

# Default command (change as needed)
CMD ["/bin/zsh"]
