require 'nokogiri'
require 'uri'
require 'set'

allowed_domains = Set["zeus.ugent.be", "pics.zeus.gent", "zinc.zeus.gent", "hydra.ugent.be", "kelder.zeus.ugent.be"]

# DO NOT ADD TO THIS LIST!
# The eventual goal is to have the exeptions list be empty by uploading these images to our own CDN and changing the links
# Hotlinking to external sites is bad for several reasons:
#  - We don't control that site: the site owner can take down the images or even replace them with others
#    This can also happen accidentally. This will lead linkrot.
#  - We would be consuming other people's resources
# Instead, you can upload images to the Zeus CDN, pics.zeus.gent
exception_counter = {
  "https://www.fosdem.org/promo/fosdem/static" => 1,
  "https://www.ubuntu.com/files/countdown/910/countdown-9.10-2/00.png" => 1,
  "https://jaspervdj.be/images/2011-05-09-12-urenloop.jpg" => 1,
  "https://jaspervdj.be/images/2011-05-09-gyrid-node.jpg" => 1,
  "https://jaspervdj.be/images/2011-05-09-gyrid-node-inside.jpg" => 1,
  "https://jaspervdj.be/images/2011-05-09-relay-batons.jpg" => 1,
  "https://jaspervdj.be/images/2011-05-09-ring.png" => 1,
  "https://jaspervdj.be/images/2011-05-09-plot.png" => 1,
  "https://jaspervdj.be/images/2011-05-09-monitoring.jpg" => 1,
  "https://ieeeerau.com/sites/default/files/ieeextreme7-banner.jpg" => 1,
  "https://www.vlaamseprogrammeerwedstrijd.be/current/layout/logoVPW2014.jpg" => 1,
  "//media.giphy.com/media/1lop3XEoCngYg/giphy.gif" => 1,
  "//i.imgur.com/ebvggMn.gif" => 1,
  "//i.imgur.com/5c22RvF.gif" => 1,
  "//media.tenor.co/images/6659f7a4dead984cdcc05903e7c9503f/tenor.gif" => 1,
  "//iruntheinternet.com/lulzdump/images/skateboarder-never-drops-it-keeps-running-runs-away-bye-14344846555.gif" => 1,
  "https://i.imgur.com/RGITm8c.gif" => 1,
  "//emoji.slack-edge.com/T02E8K8GY/zeustux/19b65368560af6c2.jpg" => 1,
  "//media.giphy.com/media/108M7gCS1JSoO4/giphy.gif" => 1,
  "https://play.google.com/intl/en_us/badges/images/generic/en_badge_web_generic.png" => 1,
  "https://plugg.eu/userfiles/images/banner468.gif" => 1,
  "https://fosdem.org/2013/assets/flyer-90dpi-240c97c7f08316d072bb684f7f9156ee454e863a9e365d8f1fb5566c200f924e.png" => 3,
  "https://fosdem.org/2014/support/promote/tower.png" => 1,
  "https://scontent-a.xx.fbcdn.net/hphotos-frc3/t1/1656245_634301396628862_879654368_n.png" => 3,
  "https://ulyssis.org/wp-content/uploads/2015/03/ULYSSIS-Jobbeurs-poster-finaal.png" => 3,
  "http://www.foneo-datacenter.eu/images/banner_ownership_eyecatcher.jpg" => 3,
  "//fosdem.org/2017/assets/style/logo-gear-7204a6874eb0128932db10ff4030910401ac06f4e907f8b4a40da24ba592b252.png" => 6,
  "https://fosdem.org/2017/assets/style/fosdem-home-visual-e16e61f851e13e834abcc31fddc09ddbc7a63a5b29147ae506e9c954e0173089.jpg" => 6,
  "https://hashcode.withgoogle.com/resources/images/hero_2.jpg" => 16,
  "http://assets.inhabitat.com/wp-content/blogs.dir/1/files/2012/03/board-games.jpg" => 3,
  "//www.johndcook.com/wordvslatex.gif" => 2,
  "https://www.vlaamseprogrammeerwedstrijd.be/current/images/VPW2018grootP.png" => 6,
  "https://preppykitchen.com/wp-content/uploads/2019/08/panncake-feature-n-768x1088.jpg" => 6,
  "https://beeld.ugent.be/files/photos/.117063/w940q85_Z2020_060_001.jpg" => 7  
}

exception_counter.default = 0

Nanoc::Check.define(:no_hotlinking) do
    @output_filenames.each do |filename|
      if filename =~ /html$/
        doc = Nokogiri::HTML.parse(File.read(filename))
        links = []
        # Find URLs in source attribute of img tags
        doc.css('img').each do |link|
            links << link.attr('src')
        end
        # Find URLs in style attributes (inline CSS)
        doc.css('[style]').each do |elem|
          link_src = elem['style'][/url\((.+)\)/, 1]
          if link_src
            links << link_src.delete('"').delete("'")
          end
        end
        links.each do |link_src|
          uri =  URI(link_src)
          unless uri.host.nil?
            unless allowed_domains.include?(uri.host.downcase)
              if exception_counter[link_src] > 0
                exception_counter[link_src] -= 1
              else
                puts link_src
                add_issue("Don't hotlink to external site #{link_src}, instead use the Zeus CDN https://pics.zeus.gent to upload your images", subject: filename)
              end
            end
          end
        end
      end
    end
    exception_counter.each do |url, amount|
      if amount != 0
        add_issue("Exceptions list in hotlinking.rb is outdated #{url} is allowed but #{amount} exceptions are left instead of zero")
      end
    end
  end