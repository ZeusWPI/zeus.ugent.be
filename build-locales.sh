#!/usr/bin/env sh
set -eu

# Clear the cache before each locale build.
rm -rf tmp/nanoc
SITE_PRODUCTION=1 \
SITE_LOCALE=nl \
bundle exec nanoc --env=prod compile

# Build English separately from Dutch.
rm -rf tmp/nanoc
SITE_PRODUCTION=1 \
SITE_LOCALE=en \
bundle exec nanoc --env=en compile