module ProjectsHelper
  def all_projects
    @items.find_all('/projects/*').sort_by{|project| -(project[:priority] || 0)}
  end
end
