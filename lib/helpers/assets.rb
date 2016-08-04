module AssetHelper
  def asset(type, identifier)
    {
      js: "<script src='/assets/scripts/#{identifier}.js'></script>",
      css: "<link rel='stylesheet' type='text/css' href='/assets/stylesheets/#{identifier}.css'>"
    }[type]
  end
end
