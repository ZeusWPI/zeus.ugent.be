# frozen_string_literal: true
source 'https://rubygems.org'

gem 'nanoc', '4.7.4'

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

group :development do
  gem 'adsf'
  gem 'highline'
  gem 'terminal-notifier-guard'
  gem 'terminal-notifier'
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
