
module TileHelper
  def get_teaser(post)
    content = strip_html(post.compiled_content)
    return truncate(content, 300)
  end

  def truncate(s, max=70, elided = ' ...')
    s.match( /(.{1,#{max}})(?:\s|\z)/ )[1].tap do |res|
      res << elided unless res.length == s.length
    end
  end

end
