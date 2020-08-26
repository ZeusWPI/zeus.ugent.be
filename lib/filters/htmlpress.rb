require 'htmlcompressor'
require 'rainpress'
require 'uglifier'

class UglifyProxy < Uglifier
  alias_method :compress, :compile
end

JS_COMPRESSOR = UglifyProxy.new
CSS_COMPRESSOR = Rainpress

Nanoc::Filter.define(:html_press) do |content, options|
  HtmlCompressor::Compressor.new(compress_javascript: true, javascript_compressor: JS_COMPRESSOR, compress_css: true, css_compressor: CSS_COMPRESSOR, remove_quotes: true, simple_boolean_attributes: true).compress content
end
