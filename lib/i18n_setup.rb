require 'i18n'

I18n.load_path += Dir[File.expand_path('../i18n/*.yml', __dir__)]

I18n.available_locales = [:en, :nl]

# Each locale is compiled in a separate Nanoc invocation, so locale state is
# fixed once when the build process starts.
locale = ENV.fetch('SITE_LOCALE', 'nl').to_sym
# Nanoc can render pages in worker threads, so their default must match the build locale.
I18n.default_locale = locale
I18n.locale = locale

# Fallback to default locale if translation is missing
I18n::Backend::Simple.include(I18n::Backend::Fallbacks)




