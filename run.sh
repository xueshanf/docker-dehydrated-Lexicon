
#!/usr/bin/env bash

interrupt() {
  echo
  echo "Caught ^C, exiting."
  exit 1
}

trap interrupt SIGINT

while true; do 
  ./dehydrated --cron --hook /dbs/hook --challenge dns-01
  ./dehydrated --cleanup
  inotifywait --timeout 86400 /letsencrypt/domains.txt
don
