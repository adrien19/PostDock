#!/usr/bin/env bash
set -e

echo ">>> Setting up STOP handlers..."
for f in TERM SIGTERM QUIT SIGQUIT INT SIGINT KILL SIGKILL; do
    trap "system_stop $f" "$f"
done

echo '>>> STARTING SSH (if required)...'
sshd_start

echo '>>> STARTING POSTGRES...'
/usr/local/bin/cluster/postgres/entrypoint.sh

/usr/local/bin/cluster/functions/keep_alive

EXIT_CODE=$?
echo ">>> Foreground processes returned code: '$EXIT_CODE'"

system_exit
exit $EXIT_CODE
