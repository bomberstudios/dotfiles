source $HOME/.macos

# eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH=.:$(brew --prefix)/bin:$HOME/bin:$PATH
export EDITOR="$(which code) -w"
LC_CTYPE=en_US.UTF-8
LC_ALL=en_US.UTF-8

alias la='ls -la'
# alias ..='cd ..' # replaced with zsh's `setopt AUTO_CD`
alias o='open .'
alias f='open . -a Fork'
alias dl='cd $HOME/Downloads'
alias tmp='cd $HOME/tmp'
alias c='code .'
alias kb='make keyboardio/atreus:bomberstudios ferris/sweep:bomberstudios crkbd:bomberstudios preonic:bomberstudios'
alias mm='make down && make start'

# Completion
# case insensitive path-completion (from https://scriptingosx.com/2019/07/moving-to-zsh-part-5-completions/)
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
# partial completion suggestions (so cd c/w/s <tab> completes to cd Code/w/Skecth)
zstyle ':completion:*' list-suffixes zstyle ':completion:*' expand prefix suffix

co () {
  cd "$HOME/Code/$1"
}

# Shell Options (from https://scriptingosx.com/2019/06/moving-to-zsh-part-3-shell-options/)
setopt NO_CASE_GLOB # Case insensitive globbing
setopt AUTO_CD
setopt CORRECT
setopt CORRECT_ALL

# History
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
setopt EXTENDED_HISTORY
SAVEHIST=5000
HISTSIZE=2000
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST 
# do not store duplications
setopt HIST_IGNORE_DUPS
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS

# substring history search using up/down arrows
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# Git Aliases
alias p='git pull --rebase --autostash'
alias P='git push'
eval "$(gh completion -s zsh)"

# Homebrew
# alias ibrew='arch -x86_64 /usr/local/bin/brew'
alias bup='brew update && brew upgrade && brew cleanup'

# if type ibrew &>/dev/null; then
#   FPATH=$(ibrew --prefix)/share/zsh/site-functions:$FPATH
# fi
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
autoload -Uz compinit
compinit

# jog https://github.com/natethinks/jog
function zshaddhistory() {
  echo "${1%%$'\n'}|${PWD}   " >> ~/.zsh_history_ext
}

# Secretive Config
export SSH_AUTH_SOCK=/Users/ale/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# https://github.com/zsh-users/zsh-autosuggestions/
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# bun completions
[ -s "/Users/ale/.bun/_bun" ] && source "/Users/ale/.bun/_bun"

# bun
export BUN_INSTALL="/Users/ale/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

source /Users/ale/.docker/init-zsh.sh || true # Added by Docker Desktop

# pnpm
export PNPM_HOME="/Users/ale/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# nvm use when changing dir - place this after nvm initialization!
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc