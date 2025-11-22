module AssetHelper
  def asset(type, identifier)
    {
      img: "<img src='/assets/images/#{identifier}' alt='#{identifier}' />",
      js: "<script src='/assets/scripts/#{identifier}.js'></script>",
      css: "<link rel='preload' href='/assets/stylesheets/#{identifier}.css' as='style' onload=\"this.onload=null;this.rel='stylesheet'\"><noscript><link rel='stylesheet' href='/assets/stylesheets/#{identifier}.css'></noscript>",
    }[type]
  end

  def zeus_logo_url(color: :black)
    "https://zinc.zeus.gent/#{color}"
  end
end
