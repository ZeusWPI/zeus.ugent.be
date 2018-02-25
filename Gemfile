# frozen_string_literal: true
source 'https://rubygems.org'

gem 'nanoc'

# General filtering
gem 'coffee-script'
gem 'icalendar' # ical files
gem 'kramdown'
gem 'sass'

# Needed for atom_feed in blogging helper
gem 'builder'

# Faster css autoprefixing
gem 'therubyracer'

# Word counting gem (which takes special characters into account)
# for reading time
gem 'words_counted'

# Compiling reports from .md to .pdf
gem 'pandoc-ruby'

group :development do
  gem 'adsf'
  gem 'highline'
  gem 'terminal-notifier'
  gem 'terminal-notifier-guard'
end

group :production do
  # Autoprefixing for class
  gem 'autoprefixer-rails'
  gem 'html_press'
end

group :nanoc do
  gem 'guard-nanoc'
end

group :test do
  # Checks
  gem 'w3c_validators'
end
