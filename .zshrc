###
# Update clear-screen to include precmd
###
clear-screen() { echoti clear; precmd; zle redisplay; }
zle -N clear-screen

###
# Aliases
###
alias list='ls -ahlvFGO'

###
# Custom Prompt (WIP)
#
# Output:
# 📁 DIRECTORY 🌱 git-branch                                         DATE 📆
# ❯                                                                     TIME 🕒
###

###
# Formatted strings
###
DIRECTORY="%F{109}📁 %(3~|…/%2~|%~)%f"
DATE="%F{242}%D{%A %Y/%m/%d} 📆%f"
TIME="%F{242}%T%f 🕒"

###
# Functions
###
function git-branch() {
  if [ $(git rev-parse --is-inside-work-tree 2>/dev/null) ]
    then
      local BRANCH_NAME="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
      local GIT_STATUS="$(git status --porcelain 2> /dev/null)"
      local COLOR=%${#GIT_STATUS}(l.'34'.'178')
      echo -e "%F{$COLOR}🌱 ${BRANCH_NAME}%f"
  fi
}

# Determining the length of a string is /not/ trivial.
# https://gist.github.com/romkatv/2a107ef9314f0d5f76563725b42f7cab#file-two-line-prompt-zsh-L45
function string-length() {
  local COLUMNS=${2:-$COLUMNS}
  local -i x y=$#1 m

  if (( y ))
    then
      while (( ${${(%):-$1%$y(l.1.0)}[-1]} ))
        do
          x=y
          (( y *= 2 ));
      done
      local xy
      while (( y > x + 1 ))
        do
          m=$(( x + (y - x) / 2 ))
          typeset ${${(%):-$1%$m(l.x.y)}[-1]}=$m
      done
  fi

  echo $x
}

# https://gist.github.com/romkatv/2a107ef9314f0d5f76563725b42f7cab#file-two-line-prompt-zsh-L67
function print-info() {
  local PADDING_LENGTH=$((
    COLUMNS - $(string-length $1) - $(string-length $2) -1
  ))

  if ((PADDING_LENGTH > 0))
    then
      local PADDING=${(pl.$PADDING_LENGTH.. .)}
      echo -e ${1}${PADDING}${2}
    else
      # Limit display to minimal info if there aren't enought columns
      echo -e ${1}
  fi
}

###
# Output
###
precmd() {
  local LEFT_INFO=${DIRECTORY}' '$(git-branch)
  local RIGHT_INFO=${DATE}
  print -rP "$(print-info "$LEFT_INFO" "$RIGHT_INFO")"
}
export PROMPT='❯ '
export RPROMPT=${TIME}

autoload -Uz compinit && compinit

export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

###
# Homebrew
###
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

export HOMEBREW_NO_ENV_HINTS=1

export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH"
export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
. /opt/homebrew/opt/asdf/libexec/asdf.sh
