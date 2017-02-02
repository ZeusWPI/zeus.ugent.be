require 'words_counted'

module BlogHelper
  def reading_time(blogpost)
    human_wpm = 200.0
    words = WordsCounted.count(blogpost.reps[:text].compiled_content).token_count

    minutes = (words / human_wpm).ceil

    if minutes == 1
      "#{minutes} minuut"
    else
      "#{minutes} minuten"
    end
  end
end
