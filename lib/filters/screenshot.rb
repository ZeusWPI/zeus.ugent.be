require 'puppeteer-ruby'

class ScreenshotFilter < Nanoc::Filter
  identifier :screenshot
  type :text => :binary

  def run(content, params = {})
    # TODO: fix this
    Puppeteer.launch(headless: false) do |browser|
      page = browser.new_page
      page.set_content(content)
      pp output_filename
      page.screenshot(path: output_filename, type: :png)
    end
    content.gsub('Nanoc sucks', 'Nanoc rocks')
  end
end
