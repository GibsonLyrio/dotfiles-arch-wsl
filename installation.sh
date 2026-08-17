#!/usr/bin/bash

# ---------------------------------------------------------------------------- #
# This script installs yay as AUR package manager, sets my zsh config, and more
# ---------------------------------------------------------------------------- #

# Exit on error
set -e


# ---------------------------------------------------------------------------- #
# Setting ~/.config directory
# ---------------------------------------------------------------------------- #
echo "------------------------------------------------------------------------"
echo "[script] >>> Starting install script..."
echo "------------------------------------------------------------------------"

# Update pacman and install stow
sudo pacman -Syu --noconfirm --needed stow git base-devel

# Clone dotfiles (if not already cloned)
if [ ! -d "$HOME/dotfiles" ]; then
    git clone https://github.com/GibsonLyrio/dotfiles-arch-wsl.git "$HOME/dotfiles" || {
        echo "[script] >>> Failed to clone dotfiles."
        exit 1
    }
fi

# Create ~/.config directory (if not already exists)
if [ ! -d "$HOME/.config" ]; then
    cd $HOME
    mkdir .config || {
        echo "[script] >>> Failed to create .config directory."
        exit 1
    }
fi

# Change to dotfiles directory
cd "$HOME/dotfiles" || {
    echo "[script] >>> Failed to change to dotfiles directory."
    echo "[script] >>> HINT: Verify if dotfiles was cloned correctly."
    exit 1
}

# Stow configuration files
stow . || {
    echo "[script] >>> Failed to stow config."
    echo "[script] >>> HINT: If some target already exist,"
    echo "[script] >>>       move to a backup, and run this script again."
    exit 1
}


# ---------------------------------------------------------------------------- #
# Installing yay (AUR helper)
# ---------------------------------------------------------------------------- #
echo "------------------------------------------------------------------------"
echo "[script] >>> Installing yay..."

if ! command -v yay &>/dev/null; then
    cd /tmp
    git clone https://aur.archlinux.org/yay.git || {
        echo "[script] >>> Failed to clone yay."
        exit 1
    }
    cd yay
    makepkg -si --noconfirm || {
        echo "[script] >>> Failed to install yay."
        exit 1
    }
fi


# ---------------------------------------------------------------------------- #
# Using yay to install additional applications
# ---------------------------------------------------------------------------- #
echo "------------------------------------------------------------------------"
echo "[script] >>> Installing applications with yay..."

echo "[script] >>> manual pages..."
yay -S --noconfirm --needed man-db man-pages texinfo

echo "------------------------------------------------------------------------"
echo "[script] >>> Terminal utils..."
yay -S --noconfirm --needed neofetch zsh zinit ttf-meslo-nerd fzf

echo "------------------------------------------------------------------------"
echo "[script] >>> Dev tools..."
yay -S --noconfirm --needed neovim micro docker openssh asdf-vm wget

# setting vim-plug for neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


# ---------------------------------------------------------------------------- #
# Installing languages with asdf
# ---------------------------------------------------------------------------- #
echo "------------------------------------------------------------------------"
echo "[script] >>> Installing languages with asdf ..."

# Setting asdf completions for ZSH
mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
asdf completion zsh >"${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"

# Adding plugins
asdf plugin add python
asdf plugin add nodejs
asdf plugin add rust

# Installing latest versions
asdf install python latest
asdf install nodejs latest
asdf install rust latest

# Setting global versions
asdf set -u python latest
asdf set -u nodejs latest
asdf set -u rust latest


# ---------------------------------------------------------------------------- #
# Changing default shell to ZSH
# ---------------------------------------------------------------------------- #
echo "------------------------------------------------------------------------"
echo "[script] >>> Changing default shell to ZSH..."

if [ "$SHELL" != "/usr/bin/zsh" ]; then
    # Change shell for the current user without asking password
    sudo chsh -s /usr/bin/zsh "$USER" || {
        echo "[script] >>> Failed to change shell to ZSH."
    }
fi

# ---------------------------------------------------------------------------- #
# Enabling WSL Interop for Windows Binaries (e.g., "code .")
# ---------------------------------------------------------------------------- #
echo "------------------------------------------------------------------------"
echo "[script] >>> Configuring WSL Interop for Windows binaries..."

# Create the binfmt configuration file
sudo sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf' || {
    echo "[script] >>> Failed to create WSLInterop.conf."
    exit 1
}


# ---------------------------------------------------------------------------- #
# Creating ssh key for github
# ---------------------------------------------------------------------------- #
echo "------------------------------------------------------------------------"
echo "[script] >>> Creating a SSH Key for GitHub..."
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "gibsonlyrio@pm.me"


# ---------------------------------------------------------------------------- #
# Final Steps
# ---------------------------------------------------------------------------- #
echo "------------------------------------------------------------------------"
echo "[script] >>> Install script finished! Reboot the system."
echo "------------------------------------------------------------------------"
