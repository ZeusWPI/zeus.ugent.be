module FontAwesomeHelper
  def fa(icon, opts = {})
    classes = ['fa', "fa-#{icon}"]

    classes << "fa-#{opts[:size]}" if opts[:size]
    classes << 'fa-li' if opts[:li]
    classes << "fa-stack-#{opts[:stack]}" if opts[:stack]
    classes << 'fa-inverse' if opts[:inverse]
    classes << opts[:class]

    "<i class='#{classes.reject(&:nil?).join(' ')}'></i>"
  end
end
