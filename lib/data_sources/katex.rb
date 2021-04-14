require 'katex'

class KatexDataSource < ::Nanoc::DataSource
  identifier :katex

  def items
    katex_css_path = File.join(Katex.gem_path, 'vendor', 'katex', 'stylesheets', 'katex.css')
    katex_font_paths = Dir[File.join(Katex.gem_path, 'vendor', 'katex', 'fonts', '*')]

    font_items = katex_font_paths.map do |e|
      font_name = File.split(e)[-1]
      new_item(File.open(e).read, {}, "/fonts/#{font_name}")
    end
    [new_item(File.open(katex_css_path).read, {}, "/katex.css")] + font_items
  end
end
