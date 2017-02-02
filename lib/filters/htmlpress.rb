require 'html_press'

Nanoc::Filter.define(:html_press) do |content, _params|
  HtmlPress.press content
end
