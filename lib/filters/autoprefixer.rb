require 'v8'
require 'autoprefixer-rails'

Nanoc::Filter.define(:autoprefixer) do |content, _params|
  AutoprefixerRails.process(content).css
end
