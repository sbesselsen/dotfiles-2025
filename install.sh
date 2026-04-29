#!/bin/sh
# Install dependencies
if command -v brew >/dev/null 2>&1; then
    brew install asdf bat btop curl eza fd fzf git jq pv ripgrep shellcheck starship tealdeer wget
fi

if command -v apk >/dev/null 2>&1; then
    SUDO=sudo
    if command -v doas >/dev/null 2>&1; then
        SUDO=doas
    fi
    $SUDO apk add bat btop curl eza fd fzf git jq less pv ripgrep shellcheck starship wget zsh

    $SUDO apk add \
    --no-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    asdf tealdeer
fi

if command -v apt-get >/dev/null 2>&1; then
    # Install dependencies for Debian/Ubuntu
    SUDO=sudo

    # Add repository for eza
    $SUDO mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | $SUDO gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | $SUDO tee /etc/apt/sources.list.d/gierens.list
    $SUDO chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list

    $SUDO apt-get update
    $SUDO apt-get install -y bat btop curl eza fd-find fzf git jq less pv ripgrep shellcheck wget zsh
    $SUDO apt-get install -y tldr
    $SUDO apt-get install -y tealdeer

    # Install Starship
    curl https://starship.rs/install.sh > install_starship.sh
    chmod +x install_starship.sh
    $SUDO ./install_starship.sh -y

    if [ ! -f /usr/bin/bat ] && [ -f /usr/bin/batcat ]; then
        $SUDO ln -s /usr/bin/batcat /usr/local/bin/bat
    fi
fi

# Initialize components
tldr --update

# Set up symlinks
DIR="$(dirname "$0")"
DIR="$(realpath "$DIR")"

mkdir -p "$HOME/.config"

ln -sf "$DIR/config/starship/starship.toml" "$HOME/.config/starship.toml"
ln -sf "$DIR/config/zsh/.zshrc" "$HOME/.zshrc"

mkdir -p "$HOME/.config/btop/themes"
ln -sf "$DIR/config/btop/catppuccin-frappe.theme" "$HOME/.config/btop/themes/catppuccin-frappe.theme"
echo 'color_theme = "catppuccin-frappe"' >> "$HOME/.config/btop/btop.conf"

# Bat theme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
bat cache --build
