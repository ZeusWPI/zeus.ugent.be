require 'pandoc-ruby'
require 'fileutils'

class PandocPDF < Nanoc::Filter
  identifier :pandoc_pdf
  type text: :binary

  def run(content, params = {})
    # https://github.com/nanoc/nanoc/blob/master/nanoc/lib/nanoc/filters/pandoc.rb
    args = params.key?(:args) ? params[:args] : params

    args[:o] = output_filename + '.pdf'

    PandocRuby.convert(content, *args)

    FileUtils.mv(output_filename + '.pdf', output_filename)
  end
end
