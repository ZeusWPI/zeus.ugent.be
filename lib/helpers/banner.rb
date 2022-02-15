require 'puppeteer-ruby'
# require 'byebug'

module BannerHelper
  # This is one big hack.
  # We basically open the file in puppeteer, render it; and then screenshot it.
  #
  # To debug this:
  # 1. set headless to false
  # 2. install and require byebug
  # 3. insert byebug before the screenshot line
  # This will keep the browser open, so you can inspect it.
  def generate_screenshot(item)
    rep = item.reps[:banner]
    Puppeteer.launch(headless: true) do |browser|
      page = browser.new_page
      page.viewport = Puppeteer::Viewport.new(width: 1920, height: 1080)
      page.goto("file:///#{rep.raw_path}", wait_until: 'networkidle0')
      basename = File.dirname(rep.raw_path)
      # byebug
      page.screenshot(path: "#{basename}/banner.png", type: :png)
    end
  end
end
