module EnvironmentHelper
  def production?
    ENV['NANOC_ENV'] == 'prod' || ENV['SITE_PRODUCTION'] == '1'
  end

  def development?
    !production?
  end
end
