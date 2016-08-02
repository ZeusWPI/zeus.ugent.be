class AutoprefixerFilter < Nanoc::Filter
  require 'autoprefixer-rails'

  identifier :autoprefixer

  def run(content, _params = {})
    AutoprefixerRails.process(content).css
  end
end
