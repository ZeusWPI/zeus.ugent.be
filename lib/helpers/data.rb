module DataHelper
  def data_from(identifier)
    @items["/data/#{identifier}.yaml"].attributes
  end
end
