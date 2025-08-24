#!/usr/bin/bash
#Project Home: https://github.com/crlamke/shutdown
#Copyright   : 2025 Christopher R Lamke
#License     : MIT - See https://opensource.org/licenses/MIT
#Purpose     : Allows you to set a system shutdown schedule and display the current shutdown schedule

function showShutdownSchedule()
{

  if [ ! -f /run/systemd/shutdown/scheduled ]; then
    printf "\nNo shutdown scheduled\n"
    return 0
  fi

  shutdownTimeMicrosecs=$(head -1 /run/systemd/shutdown/scheduled | cut -d= -f 2)
  shutdownTimeSecs=$((shutdownTimeMicrosecs / 1000000))
  currentTimeSecs=$(date +%s)
  totalSecsTillShutdown=$((shutdownTimeSecs - currentTimeSecs))
  hoursTillShutdown=$((totalSecsTillShutdown / 3600))
  minutesTillShutdown=$(((totalSecsTillShutdown % 3600) / 60))
  secsTillShutdown=$((totalSecsTillShutdown % 60))
  timeZone=$(date +%Z)
  shutdownTime=$(date -d "@$shutdownTimeSecs" +"%b %d at %T")
  printf "\nShutdown scheduled for %s %s, %s hours, %s minutes, %s seconds from now\n" \
          "$shutdownTime" "$timeZone" "$hoursTillShutdown" "$minutesTillShutdown" \
          "$secsTillShutdown"
}

# The "+720" parameter tells the shutdown command to schedule the system
# to shut down in 720 minutes (12 hours).
function setShutdownSchedule()
{
  if [ ! -f /run/systemd/shutdown/scheduled ]; then
    sudo shutdown +720 >>/dev/null 2&>1
  fi
}
