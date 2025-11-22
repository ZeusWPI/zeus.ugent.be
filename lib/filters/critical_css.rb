require 'fileutils'
require 'open3'

class CriticalCSS < Nanoc::Filter
  identifier :critical_css
  type text: :text

  def run(content, params = {})
    args = params.key?(:args) ? params[:args] : params
  
    output, status = Open3.capture2e("npx critical --inline --base output", stdin_data: content)

    if status.exitstatus != 0
      raise "CriticalCSS filter failed: #{output}"
    end

    output
  end
end
