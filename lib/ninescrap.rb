require "ninescrap/version"
require "ninescrap/Post"
require 'ninescrap/Comment'
require 'json'
require 'uri'

module NineScrap

  # Given a array of urls,
  # Loads them and returns an array
  # of Posts ready to be JSONized
  def self.fromArray urls
    if urls.kind_of?(Array)
      posts = Array.new
      urls.each do |url|
        if validUrl url
          p = Post.new url
          p.loadFullPage
          posts.push p
        else
          raise "Invalid URL : '#{url}'"
        end
      end
      return posts
    else
      raise "fromArray expects an array of valid urls."
    end
  end

  # Given a valid url, returns the post
  # loaded, ready to be JSONized.
  def self.fromUrl url
    if validUrl url
      p = Post.new url 
      p.loadFullPage
      return p
    else
      raise "Invalid URL : #{url}"
    end
  end


  # Given a section,
  # loads the top post and scraps it,
  # before going to the next one, and so on...
  def self.fromSection url


  end

  # returns true if url is a valid
  # url and from Nine
  def self.validUrl url
    url =~ URI::regexp and url =~ /\b(?:https?:\/\/)?9gag\.com\/[A-Za-z0-9\/]+/
  end

end
