require 'ninescrap'

# Standard usage
post = NineScrap.fromUrl "http://9gag.com/gag/aeYB7rO"
puts JSON.generate post

# Multiple urls to fetch
urls = Array.new
urls.push "http://9gag.com/gag/aeYB7rO"
posts = NineScrap.fromArray urls
posts.each do |p|
  puts JSON.generate p
end
