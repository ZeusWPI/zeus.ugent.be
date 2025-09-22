module I18nHelper
  def t(key, **options)
    I18n.t(key, **options)
  end
end