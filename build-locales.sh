#!/usr/bin/env sh
set -eu

# build shared assets and reports once in a temporary output directory.
rm -rf tmp/nanoc output/shared output/assets

SITE_PRODUCTION=1 SITE_LOCALE=nl \
  bundle exec nanoc --env=shared compile \
  --focus='/assets/scripts/**/*.js' \
  --focus='/assets/stylesheets/**/*.scss' \
  --focus='/assets/stylesheets/**/*.css' \
  --focus='/assets/images/**/*' \
  --focus='/about/verslagen/**/*'

# move the shared files to the public paths used by both locales.
mv output/shared/assets output/assets
mkdir -p output/about/verslagen
cp -r output/shared/about/verslagen/*/ output/about/verslagen/
rm -rf output/shared

build_locale() {
  locale=$1
  environment=$2

  rm -rf tmp/nanoc "output/$locale"

  # build every locale item, skipping only assets and report PDFs already built above.
  SITE_PRODUCTION=1 SITE_LOCALE="$locale" SKIP_SHARED=1 \
    bundle exec nanoc --env="$environment" compile
}

build_locale nl nl_prod
build_locale en en_prod