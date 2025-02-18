require 'pandoc-ruby'
require 'fileutils'

class PandocPDF < Nanoc::Filter
  identifier :pandoc_pdf
  type text: :binary

  def run(content, params = {})
    # https://github.com/nanoc/nanoc/blob/master/nanoc/lib/nanoc/filters/pandoc.rb
    args = params.key?(:args) ? params[:args] : params

    args[:o] = output_filename + '.pdf'

    # Make sure all backslashes are escaped in the LaTeX code
    content = content.gsub('\\', '\\\\')
    # Also escape tildes
    content = content.gsub('~', '\textasciitilde{}')
    # And remove any markdown images
    content = content.gsub(/!\[.*\]\(.*\)/, '')

    PandocRuby.convert(content, *args)

    FileUtils.mv(output_filename + '.pdf', output_filename)
  end
end
