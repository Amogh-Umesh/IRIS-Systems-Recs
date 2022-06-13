#!/bin/bash
set -e
# cd /iris_shopping_app
echo "Setting up Database server"
bundle exec rake db:create --trace
bundle exec rake db:migrate --trace
echo "Database server ready"
rails server -b 0.0.0.0