module TileHelper
  def get_teaser(post)
    # excerptize is part of the TextHelper, given by nanoc
    # https://nanoc.ws/doc/reference/helpers/#text
    excerptize(post.reps[:text].compiled_content, length: 300)
  end
end
