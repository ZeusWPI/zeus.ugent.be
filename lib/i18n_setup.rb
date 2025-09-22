require 'i18n'

I18n.load_path += Dir[File.expand_path('../i18n/*.yml', __dir__)]

I18n.default_locale = :en

I18n.available_locales = [:en, :nl]

# Fallback to default locale if translation is missing
I18n::Backend::Simple.include(I18n::Backend::Fallbacks)




