class StripFilter < Nanoc::Filter
  identifier :strip_html

  def run(content, _params = {})
    strip_html(content)
  end
end
