module NavigationHelper
  def nav_items
    navigables = items.select { |i| i[:navigable] }

    navigables.each do |item|
      is_active = @item_rep && @item_rep.path == item.path
      yield item, is_active
    end
  end
end
