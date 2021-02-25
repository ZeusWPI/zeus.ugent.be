require 'words_counted'

module BlochHelper
  def reading_time(blochpost)
    human_wpm = 200.0
    words = WordsCounted.count(blochpost.compiled_content(rep: :text)).token_count

    minutes = (words / human_wpm).ceil

    if minutes == 1
      "#{minutes} minuut"
    else
      "#{minutes} minuten"
    end
  end

  def figure(img_url, caption, alt = nil, img_class: nil)
    alt ||= caption
    <<~HTML
      <figure class="image #{img_class}">
        <a href="#{img_url}">
          <img src="#{img_url}" alt="#{alt}">
        </a>
        <figcaption>#{caption}</figcaption>
      </figure>
    HTML
  end
end
