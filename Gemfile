# frozen_string_literal: true
source 'https://rubygems.org'

gem 'nanoc', '4.4.7'
gem 'kramdown'
gem 'coffee-script'
gem 'sass'
# Needed for atom_feed in blogging helper
gem 'builder'

# ical files
gem 'icalendar'

gem 'therubyracer'

# Word counting gem (which takes special characters into account)
# for reading time
gem 'words_counted'

group :development do
  gem 'adsf'
  gem 'highline'
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
