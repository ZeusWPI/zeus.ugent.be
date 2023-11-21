require 'words_counted'

module BlogHelper
  def reading_time(blogpost)
    human_wpm = 200.0
    words = WordsCounted.count(blogpost.compiled_content(rep: :text)).token_count

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

  def current_academic_year
    year = Time.current.year
    month = Time.current.month
    start_year = month < 9 ? year - 1 : year
    "#{start_year % 100}-#{(start_year + 1) % 100}"
  end
end
