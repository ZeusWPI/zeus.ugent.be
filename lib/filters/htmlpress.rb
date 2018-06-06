require 'htmlcompressor'

Nanoc::Filter.define(:html_press) do |content, _params|
  HtmlCompressor::Compressor.new.compress content
end
