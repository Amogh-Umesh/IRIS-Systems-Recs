#!/bin/bash
set -e
rm -rf /iris_shopping_app/tmp/pids/server.pid
echo "Initialized Container"
# cd /iris_shopping_app
exec "$@"