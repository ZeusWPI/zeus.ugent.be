module PrivacyHelper

  def all_privacy_projects
    @items.find_all('/privacy/*')
  end

  def privacy_projects(status)
    all_privacy_projects
        .select {|project| project[:status] == status}
        .sort_by {|project| project[:name]}
  end
end
