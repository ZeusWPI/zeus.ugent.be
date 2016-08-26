module AssetHelper
  def asset(type, identifier)
    {
      img: "<img src='/assets/images/#{identifier}'/>",
      js: "<script src='/assets/scripts/#{identifier}.js'></script>",
      css: "<link rel='stylesheet' type='text/css' href='/assets/stylesheets/#{identifier}.css'>"
    }[type]
  end
end
