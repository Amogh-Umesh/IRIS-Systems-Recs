#!/bin/bash
set -e
rm -rf /iris_shopping_app/tmp/pids/server.pid
exec "$@"