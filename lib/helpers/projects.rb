module ProjectsHelper

  def all_project_items
    @items.find_all('/projects/*')
  end

  def all_projects
    all_project_items.sort_by{|project| -(project[:priority] || 0)}
  end
end
