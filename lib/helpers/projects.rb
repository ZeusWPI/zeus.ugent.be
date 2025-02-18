module ProjectsHelper

  def all_project_items
    @items.find_all('/projects/*')
  end

  def active_projects
    all_project_items
      .find_all{|project| project[:active]}
      .sort_by{|project| -(project[:priority] || 0)}
  end

  def dormant_projects
    all_project_items
      .find_all{|project| !project[:active]}
      .sort_by{|project| -(project[:priority] || 0)}
  end
end
