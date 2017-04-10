###
# Handy Ember NomBom
# N.B. Meant to be used with Super Spinner
# https://gist.github.com/zulaica/9e971cc5b6dbd156abcd13745beff262
#
# Usage:
# $ nombom
#
# WTF:
# 1. Delete node_modules, bower_components, dist, and tmp directories
# 2. Clear both NPM and Bower caches
# 3. Prevent macOS Spotlight from indexing node_modules and bower_components
# 4. Install NPM and Bower packages
# 5. Reset watchman
# 6. Display a success message
###
alias nbDelete="rm -rf node_modules/* bower_components/* dist tmp"
alias nbCache="npm cache clean --silent && bower cache clean --silent"
alias nbScaffold="touch node_modules/.metadata_never_index && touch bower_components/.metadata_never_index"
alias nbInstall="npm install --silent > /dev/null 2>&1 && bower install --silent > /dev/null 2>&1"
alias nbWatchman="watchman watch-del $PWD > /dev/null 2>&1 ; watchman watch-project $PWD > /dev/null 2>&1"
nbsuccess() {
  local MESSAGE="💥💥💥 💣 ❕❗️ 𝔑 𝟎 𝔐 𝔅 𝟎 𝔐 ❗️❕ 💣 💥💥💥"
  local NUM_COLS=$( tput cols )
  local NUM_ROWS=$( tput lines )
  local OFFSET_MESSAGE=$(( ${#MESSAGE} / 2 ))
  local OFFSET_COLS=$(( NUM_COLS / 2 - OFFSET_MESSAGE ))
  local OFFSET_ROWS=$(( NUM_ROWS / 2 ))

  tput clear
  tput civis
  tput cup $OFFSET_ROWS $OFFSET_COLS
  echo "$MESSAGE"
  sleep 2
  tput cnorm
  tput clear
}
nombom() {
  nbDelete & superSpinner $! "Deleting old files"
  nbCache & superSpinner $! "Clearing NPM and Bower caches"
  nbScaffold & superSpinner $! "Preventing macOS Spotlight from indexing"
  nbInstall & superSpinner $! "Installing NPM and Bower packages"
  nbWatchman & superSpinner $! "Resetting Watchman"
  nbsuccess
}
