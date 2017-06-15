###
# Super Prompt
#
# Output:
# 📂 WORKING_DIRECTORY : 🌱 GIT_BRANCH
# 💎 RUBY_VERSION-pPATCH@GEMSET : 🛤 RAILS_VERSION : 🐹 EMBER_VERSION : 💠 NODE_VERSION
# 💰
#
# WTF:
# 1. WORKING_DIRECTORY displays in the default color.
# 2. GIT_BRANCH only displays when working in a directory with git initialized.
# 3. GIT_BRANCH displays in light green when clean, light yellow when dirty.
# 4. RUBY_VERSION displays in light red.
# 5. Ruby PATCH number and GEMSET display only if they are not the default.
# 6. RAILS_VERSION displays in light grey, if installed.
# 7. EMBER_VERSION displays in orange.
# 8. NODE_VERSION displays in dark green.
# 9. 💰 is your prompt
#
###

###
# Formatting
###
C_DEFAULT="\x1B[00m"
C_DIVIDER="\x1B[90m"     # Dark Grey
C_EMBER="\x1B[38;5;214m" # Orange
C_GIT_CLEAN="\x1B[92m"   # Light Green
C_GIT_DIRTY="\x1B[93m"   # Light Yellow
C_RAILS="\x1B[37m"       # Light Grey
C_RUBY="\x1B[91m"        # Light Red
C_NODE="\x1B[38;5;34m"   # Dark Green

DIVIDER="$C_DIVIDER : $C_DEFAULT"
HORIZONTAL_RULE="$C_DIVIDER\n
\r╠══════════════════════════════════════════════════════════════════════════════╣\n
$C_DEFAULT"

###
# Functions
###
currentGitBranch() {
  GIT_STATUS="$(git status --porcelain 2> /dev/null)"
  if [[ ${GIT_STATUS} == "" ]]
  then
    C_GIT_STATUS=${C_GIT_CLEAN}
  else
    C_GIT_STATUS=${C_GIT_DIRTY}
  fi

  CURRENT_BRANCH=$(git branch 2> /dev/null | awk -F'^* ' '{printf $2}')
  [ "$CURRENT_BRANCH" != "" ] && CURRENT_BRANCH="🌱  $CURRENT_BRANCH"
  if [ "$CURRENT_BRANCH" != "" ]
  then
    echo -e "$DIVIDER$C_GIT_STATUS$CURRENT_BRANCH"
  fi
}

currentRubyAndGemset() {
  RUBY=$(echo "$RUBY_VERSION" | awk -F'-' '{print $2}')
  RUBY_PATCH=$(echo "$MY_RUBY_HOME" | awk -F'p' '{print $2}')
  [ "$RUBY_PATCH" != "" ] && RUBY_PATCH="-p$RUBY_PATCH"
  GEMSET=$(echo "$GEM_HOME" | awk -F'@' '{print $2}')
  [ "$GEMSET" != "" ] && GEMSET="@$GEMSET"
  echo -e "💎  $C_RUBY$RUBY$RUBY_PATCH$GEMSET$DIVIDER"
}

currentRails() {
  # `rails --version` is slower to execute when a non-default version of Rails
  # is being used. First check to see if a Gemfile.lock exists and parse the
  # Rails version out of it, otherwise just run `rails --version`.
  if [ -f Gemfile.lock ]
  then
    RAILS=$(awk '/( rails )/ { print $2 }' Gemfile.lock)
    RAILS=$(echo "$RAILS" | awk '{ gsub ("[()=<>]", ""); print $0 }')
  else
    RAILS=$(rails --version | awk -F'Rails ' '{ print $2 }')
    [ "$RAILS" != "" ] && rails="$rails"
  fi
  echo -e "🛤  $C_RAILS$RAILS$DIVIDER"
}

currentNode() {
  NODE=$(node --version)
  echo -e "💠  $C_NODE$NODE$C_DEFAULT"
}

currentEmber() {
  EMBER=$(ember version | awk -F'ember-cli: ' '{ print $2 }')
  echo -e "🐹  $C_EMBER$EMBER$DIVIDER"
}

###
# Output
###
PS1="$(echo -e $HORIZONTAL_RULE)
📂  \W\$(currentGitBranch)
\$(currentRubyAndGemset)\$(currentRails)\$(currentEmber)\$(currentNode)
💰  "

export PS1
