###
# Update clear-screen to include precmd
###
clear-screen() { echoti clear; precmd; zle redisplay; }
zle -N clear-screen

###
# Custom Prompt (WIP)
#
# Output:
#  📁 DIRECTORY 🌱 git-branch                                         DATE 📆
# ❯                                                                     TIME 🕒
###

###
# Formatted strings
###
DIRECTORY="%F{109}📁 %(3~|…/%2~|%~)%f"
DATE="%F{240}%D{%A %Y/%m/%d} 📆%f"
TIME="%F{240}%T%f 🕒"

###
# Functions
###
function git-branch() {
  local BRANCH_NAME="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  if [ $? -eq 0 ]
    then
      local GIT_STATUS="$(git status --porcelain 2> /dev/null)"
      local COLOR=%${#GIT_STATUS}(l.'34'.'178')
      echo -e "%F{$COLOR}🌱 ${BRANCH_NAME}%f"
  fi
}

###
# Output
###
precmd() {
  local LEFT_INFO=' '${DIRECTORY}' '$(git-branch)
  local RIGHT_INFO=${DATE}
  print -rP ${LEFT_INFO}${RIGHT_INFO}
}
export PROMPT='❯ '
export RPROMPT=${TIME}

###
# Enable Git tab completion
# https://github.com/git/git/tree/master/contrib/completion
###
# fpath=(~/.zsh $fpath)
autoload -Uz compinit && compinit

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
