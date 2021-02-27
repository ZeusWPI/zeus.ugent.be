# frozen_string_literal: true
source 'https://rubygems.org'

gem 'nanoc'

gem 'icalendar' # ical files
gem 'kramdown'
gem 'sassc'
gem 'typogruby'

# Needed for atom_feed in blogging helper
gem 'builder'

# Word counting gem (which takes special characters into account)
# for reading time
gem 'words_counted', git: 'https://github.com/werthen/words_counted'

group :development do
  gem 'adsf'
  gem 'thin'
  gem 'highline'
  gem 'terminal-notifier'
  gem 'terminal-notifier-guard'
end

group :production do
  # Faster css autoprefixing
  gem 'mini_racer'
  # Autoprefixing for class
  gem 'autoprefixer-rails'
  gem 'htmlcompressor'
  gem 'yui-compressor'
  # Compiling reports from .md to .pdf
  gem 'pandoc-ruby'

  gem 'uglifier', '>= 4.0.0'
  gem 'rainpress'
end

group :nanoc do
  gem 'guard-nanoc'
end

group :test do
  # Checks
  gem 'w3c_validators'
end
