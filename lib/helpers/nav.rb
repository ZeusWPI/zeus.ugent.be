module NavigationHelper
  def nav_items
    navigables = items.select { |i| i[:navigable] }.sort_by { |x| x[:order] || 10000 }

    navigables.each do |item|
      is_active = @item_rep && @item_rep.path == item.path
      yield item, is_active
    end
  end
end
