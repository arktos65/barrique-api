#!/usr/bin/env sh
# This entrypoint script is run when the container starts, initializing the database instance and running
# the migration.  Use only for development, not production.
set -e

if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
fi

bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup

exec bundle exec "$@"
