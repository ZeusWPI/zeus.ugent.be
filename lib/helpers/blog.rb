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

  def gitctime
    # find file last modification time
    filepath=@item[:content_filename]
    str=`git log --format=%cd --date=short -- #{filepath} | tail -1`
    return Date.parse(str)
  end
  
  def gitmtime
    # find file last modification time
    filepath=@item[:content_filename]
    str=`git log -1 --format=%cd --date=short -- #{filepath}`
    return Date.parse(str)
  end
  

end
