###
# Super Spinner
# An emoji-based spinner — because ASCII is boring.
#
# Usage:
# $ COMMAND & superSpinner $! "Message"
#
# Example:
# $ sleep 5 & superSpinner $! "Sleeping for 5 seconds"
#
# Output:
# $ 🕐 Sleeping for 5 seconds...
# $ 💥 Sleeping for 5 seconds.... Finished!
###
superSpinner() {
  local PID=$1
  local CLOCK_STR=("🕐" "🕑" "🕒" "🕓" "🕔" "🕕" "🕖" "🕗" "🕘" "🕙" "🕚" "🕛")
  local INDEX=0

  tput civis
  echo -ne "\r"

  while kill -0 "$PID" 2> /dev/null ; do
    echo -ne "${CLOCK_STR[$INDEX]}  $2...\r"
    INDEX=$(( INDEX == 11 ? 0 : INDEX + 1 ))
    sleep 0.08333333333
  done

  echo -ne "\r💥  $2.... Finished!"
  echo
  tput cnorm
}
