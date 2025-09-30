module I18nHelper
  def t(key, **options)
    I18n.t(key, **options)
  end

  def l(object, **options)
    I18n.l(object, **options)
  end
end