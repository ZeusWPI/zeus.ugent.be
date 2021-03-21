require 'typogruby'

Nanoc::Filter.define(:typogruby_custom) do |content, _params|
  filters = [:amp, :widont, :smartypants, :initial_quotes]
  filters.reduce(content) {|text, filt| Typogruby.send(filt, text)}
end
