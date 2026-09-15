module AssetHelper
  def asset(type, identifier)
    {
      img: "<img src='#{localized_path("/assets/images/#{identifier}")}' alt='#{identifier}' />",
      js: "<script src='#{localized_path("/assets/scripts/#{identifier}.js")}'></script>",
      css: "<link rel='stylesheet' type='text/css' href='#{localized_path("/assets/stylesheets/#{identifier}.css")}'>"
    }[type]
  end

  def zeus_logo_url(color: :black)
    "https://zinc.zeus.gent/#{color}"
  end
end
