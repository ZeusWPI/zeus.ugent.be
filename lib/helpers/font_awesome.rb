module FontAwesomeHelper
  def fa(icon, size: nil, li: false, stack: nil, inverse: false)
    classes = ['fa', "fa-#{icon}"]

    classes << "fa-#{size}" if size
    classes << 'fa-li' if li
    classes << "fa-stack-#{stack}" if stack
    classes << 'fa-inverse' if inverse

    "<i class='#{classes.join(' ')}'></i>"
  end
end
