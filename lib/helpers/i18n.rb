module I18nHelper
  def current_locale
    ENV.fetch('SITE_LOCALE', 'nl').to_sym
  end

  def localized_path(path)
    path = path.to_s
    return path unless path.start_with?('/')

    # Nanoc paths do not include the locale because both locale builds share
    # the same source tree; add it only when rendering a site link.
    return path if path.match?(%r{^/(?:en|nl)(?:/|$)})

    "/#{current_locale}#{path}"
  end

  def alternate_locale
    current_locale == :nl ? :en : :nl
  end

  def alternate_locale_path
    path = @item.path.nil? || @item.path.empty? ? '/' : @item.path
    "/#{alternate_locale}#{path}"
  end

  def t(key, **options)
    I18n.t(key, **options.merge(locale: current_locale))
  end

  def l(object, **options)
    I18n.l(object, **options.merge(locale: current_locale))
  end
end