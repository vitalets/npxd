#!/bin/sh
# If inside container - just run command.
# If outside container - ensure container is running and run command inside container.
#
# USAGE:
# ./npxd.sh <command>
#
# See: https://github.com/vitalets/npxd

set -e

if grep -sq docker /proc/1/cgroup; then
  npx "$@"
else
  docker-compose up -d
  service=$(cat ./.npxdrc 2>/dev/null || echo "")
  if [ "$service" == "" ]; then
    service=$(docker-compose ps --services --filter source=build | head -n 1)
  fi
  docker-compose exec -T $service npx "$@"
fi
