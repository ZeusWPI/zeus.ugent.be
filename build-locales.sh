#!/usr/bin/env sh
# exits on error and undefined variable
set -eu

# Build common assets once in a temporary output directory.
rm -rf tmp/nanoc output/shared output/assets
SITE_PRODUCTION=1 \
SITE_LOCALE=nl \
# limit the focus to assets and about/verslagen, since we don't want to build the entire site for each locale
bundle exec nanoc --env=shared compile \
	--focus='/assets/scripts/**/*.js' \
	--focus='/assets/stylesheets/**/*.scss' \
	--focus='/assets/stylesheets/**/*.css' \
	--focus='/assets/images/**/*' \
	--focus='/about/verslagen/**/*'

# move shared assets and copy about/verslagen to final output directory
mv output/shared/assets output/assets
mkdir -p output/about/verslagen
cp -r output/shared/about/verslagen/*/ output/about/verslagen/
# remove the temporary output directory
rm -rf output/shared

# build site for each locale
build_locale() {
	locale=$1
	environment=$2

	# remove temp output directory and final output directory for locale to ensure a clean build
	rm -rf tmp/nanoc "output/$locale"
	# set locale and environment variables and build site for the given locale
	SITE_PRODUCTION=1 \
	SITE_LOCALE="$locale" \
	# limit the focus to the relevant files for the given locale
	bundle exec nanoc --env="$environment" compile \
		--focus='/*.erb' \
		--focus='/*.html' \
		--focus='/*.ics' \
		--focus='/*.json' \
		--focus='/*.md' \
		--focus='/*.txt' \
		--focus='/*.xml' \
		--focus='/about/*.erb' \
		--focus='/about/*.md' \
		--focus='/blog*' \
		--focus='/cammie*' \
		--focus='/contact*' \
		--focus='/csvdata*' \
		--focus='/events*' \
		--focus='/projects*' \
		--focus='/search*' \
		--focus='/sponsors*' \
		--focus='/well-known*'
}

build_locale nl nl_prod
build_locale en en_prod