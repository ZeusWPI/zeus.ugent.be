module NavigationHelper
  def nav_items
    navigables.each do |item|
      # Kind of hacky way to check if page is child of another page
      root = %r{/[^\/]*/}.match(item.path)[0]

      is_active = @item_rep && @item_rep.path.start_with?(root)

      yield item, is_active
    end
  end

  def navigables
    items.select { |i| i[:navigable] }.sort_by { |x| x[:order] || 10_000 }
  end
end
