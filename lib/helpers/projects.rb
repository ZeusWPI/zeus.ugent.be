require 'uri'
module ProjectsHelper
  def all_projects
    @items.find_all('/projects/*')
  end
  # Inline a svg file.
  def svg(name)
    File.open("content/assets/images/#{name}.svg", "rb") do |file|
      "<div>" + file.read + "</div>"
    end
  end
end
