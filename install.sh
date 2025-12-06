#!/bin/sh
# Install dependencies
if command -v brew >/dev/null 2>&1; then
    brew install asdf bat btop curl eza fd fzf git jq pv ripgrep shellcheck starship tealdeer wget
fi

if command -v apk >/dev/null 2>&1; then
    apk add bat btop curl eza fd fzf git jq pv ripgrep shellcheck starship wget

    apk add \
    --no-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    asdf tealdeer
fi

# Initialize components
tldr --update

# Set up symlinks
DIR="$(dirname "$0")"
DIR="$(realpath "$DIR")"

ln -sf "$DIR/config/starship/starship.toml" "$HOME/.config/starship.toml"
ln -sf "$DIR/config/zsh/.zshrc" "$HOME/.zshrc"
