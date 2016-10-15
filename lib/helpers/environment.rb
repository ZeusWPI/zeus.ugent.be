module EnvironmentHelper
  def production?
    ENV['ZEUS_PRODUCTION']
  end

  def development?
    !production?
  end
end
