module PrivacyHelper

  def all_privacy_items
    @items.find_all('/about/privacy/*')
  end

  def privacy_projects(status)
    all_privacy_items
        .select {|project| project[:status] == status}
        .sort_by {|project| project[:name]}
  end
end
