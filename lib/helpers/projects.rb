module ProjectsHelper
  def all_projects
    @items.find_all('/projects/*')
  end
end
