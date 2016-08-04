module FontAwesomeHelper
  def fa(icon, size: nil, li: false, inline: false)
    classes = ['fa', "fa-#{icon}"]

    classes << "fa-#{size}" if size
    classes << 'fa-li' if li

    "<i class='#{classes.join(' ')}'></i>"
  end
end
