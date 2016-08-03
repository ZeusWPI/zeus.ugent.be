module DataHelper
  def data_from(identifier)
    data = YAML.load_file("data/#{identifier}.yaml")
    data.each do |d|
      p d
    end
    data
  end
end
