module EnvironmentHelper
  def production?
    ENV['NANOC_ENV'] == 'prod'
  end

  def development?
    !production?
  end
end
