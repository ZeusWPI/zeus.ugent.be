require 'htmlcompressor'

Nanoc::Filter.define(:html_press) do |content, options|
  HtmlCompressor::Compressor.new(compress_javascript: true, compress_css: true, remove_quotes: true, simple_boolean_attributes: true).compress content
end
