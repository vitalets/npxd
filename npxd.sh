#!/bin/sh
# If inside container - just run command.
# If outside container - ensure container is running and run command inside container.
#
# See: https://github.com/vitalets/npxd

set -e

if [ $# -eq 0 ]; then
  echo "USAGE: npxd <command> OR ./npxd.sh <command>"
  exit 0
fi

if grep -sq docker /proc/1/cgroup || [ -f /.dockerenv ]; then
  # In node v16 command npx "$@" does not work stable any more 
  # because $@ can contain not npm package executable (e.g. env)
  # After playing a lot with qoutes I found only this solution:
  eval "npx -c '$@'"
else
  docker compose up -d
  service=$(cat ./.npxdrc 2>/dev/null || echo "")
  if [ "$service" == "" ]; then
    services=$(docker compose ps --services)
    service=$(echo "$services" | head -n 1)
    if [ "$service" != "$services" ]; then
      echo "Several services found. Please provide .npxdrc file with service name."
      exit 1
    fi
  fi
  docker compose exec "$service" npx npxd "$@"
fi
