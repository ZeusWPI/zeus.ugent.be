module ReportsHelper
  def reports
    @items.find_all('/about/verslagen/*/*').sort_by(&:identifier).reverse
  end
end
