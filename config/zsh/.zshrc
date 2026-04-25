alias kns="kubie ns"
alias kctx="kubie ctx"
alias k="kubectl"
alias ls='eza'
alias man='tldr'
alias cat='bat'
alias l='ls -la'
alias cl='bat -n -l'
alias c='bat -n'
alias p='pnpm'

cdr() {
  root_dir="$(git rev-parse --show-toplevel)"
  if [[ "$1" = "-l" ]]; then
    ls $root_dir
  else
    cd $root_dir/$1
  fi
}

# Make my own scripts accessible on the path.
export PATH="$PATH:$HOME/.dotfiles/scripts"

# Support local paths in devcontainers etc.
export PATH="$HOME/.local/bin:$PATH"

if [ -d /opt/homebrew ]; then
    # Use some tools from Homebrew instead of the system ones.
    export PATH="/opt/homebrew/opt/curl/bin:$PATH"
    export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
fi

# AWS profile selection (from oh-my-zsh aws plugin)
function awsenv() {
  if [[ -z "$1" ]]; then
    unset AWS_DEFAULT_PROFILE AWS_PROFILE AWS_EB_PROFILE AWS_PROFILE_REGION
    echo AWS profile cleared.
    return
  fi

  local -a available_profiles
  available_profiles=($(aws_profiles))
  if [[ -z "${available_profiles[(r)$1]}" ]]; then
    echo "${fg[red]}Profile '$1' not found in '${AWS_CONFIG_FILE:-$HOME/.aws/config}'" >&2
    echo "Available profiles: ${(j:, :)available_profiles:-no profiles found}${reset_color}" >&2
    return 1
  fi

  export AWS_DEFAULT_PROFILE=$1
  export AWS_PROFILE=$1
}

function aws_profiles() {
  aws --no-cli-pager configure list-profiles 2> /dev/null && return
  [[ -r "${AWS_CONFIG_FILE:-$HOME/.aws/config}" ]] || return 1
  grep --color=never -Eo '\[.*\]' "${AWS_CONFIG_FILE:-$HOME/.aws/config}" | sed -E 's/^[[:space:]]*\[(profile)?[[:space:]]*([^[:space:]]+)\][[:space:]]*$/\2/g'
}

function _aws_profiles() {
  reply=($(aws_profiles))
}

compctl -K _aws_profiles awsenv

function kctxreset() {
  for VAR in $(env | grep KUBIE_ | sed 's/=.*$//'); do
    unset $VAR
  done
  unset KUBECONFIG
}

setopt HIST_IGNORE_SPACE

eval "$(starship init zsh)"

# Nice highlighting for bat (aliased by cat)
export BAT_THEME="Catppuccin Frappe"

source <(fzf --zsh)

# asdf - The version manager for the shell
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
autoload -Uz compinit && compinit

# Disable NodeJS on my main machine; only allow in dev containers
if command -v brew >/dev/null 2>&1; then
    asdf set -u nodejs system
fi

# Make `less` handle unicode properly (for paging things with Nerd font glyphs)
export LESSUTFCHARDEF=E000-F8FF:p,F0000-FFFFD:p,100000-10FFFD:p
