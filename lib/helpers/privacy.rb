module PrivacyHelper
  def privacy_projects(status)
    @items.find_all('/privacy/*')
        .select {|project| project[:status] == status}
        .sort_by {|project| project[:name]}
  end
end
