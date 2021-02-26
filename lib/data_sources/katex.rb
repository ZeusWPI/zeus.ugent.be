require 'katex'

class KatexDataSource < ::Nanoc::DataSource
  identifier :katex

  def items
    katex_css_path = File.join(Katex.gem_path, 'vendor', 'katex', 'stylesheets', 'katex.css')

    [
      new_item(
        File.open(katex_css_path).read,
        {},
        "/katex.css"
      )
    ]
  end
end
