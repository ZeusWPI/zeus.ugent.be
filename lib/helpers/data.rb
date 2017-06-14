module DataHelper
  def data_from(identifier)
    @items["/data/#{identifier}"].attributes[:data]
  end
end
