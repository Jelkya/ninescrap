require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'watir'
require 'headless'
require 'watir-scroll'
require 'chronic'

class Post
  attr_reader :self
  
  # Post.new 'http://9gag.com/gag/aeYB7rO'
  def initialize url
    @url = url
    @id = @url.split('/')[-1]
    @comments = Array.new
  end
  

  # Id getter
  def id
    @id
  end
  
  # Image accessors
  def img=(img)
    @img=img
  end
  def img
    @img
  end

  # Upvotes accessors
  def upvotes=(upvotes)
    @upvotes=upvotes
  end
  def upvotes
    @upvotes
  end
  
  # Url getter
  def url
    @url
  end

  # Title accessors
  def title=(title)
    @title=title
  end
  def title
    @title
  end

  # Number of all comments
  def nbComments=(nbComments)
    @nbComments=nbComments
  end
  def nbComments
    @nbComments
  end

  # comments getter
  def comments
    @comments
  end

  # toString override
  def to_s
    "Url: #{@url}\nTitle: #{@title}\nImage: #{@img}\nUpvotes: #{@upvotes}\nComments: #{@nbComments}"
  end

  
  ##
  # Main methods
  ##

  
  # Use the url given @ Post initialization
  # to scrap all the content of a post
  def loadFullPage
    # headless uses Watir to use browser navigation
    # without actually opening the browser
    headless = Headless.new
    headless.start
    b = Watir::Browser.start @url
    b.div(:class => 'comment-entry').wait_until_present # loads the 20 first comments
    current_page= Nokogiri::HTML(b.html) 
    nbComments = current_page.css("article")[0]["data-entry-comments"]
    
    # While not at the very bottom of the page
    # There will be a 'load more' button
    # while !b.element(:class =>"badge-load-more-trigger").exists? do
    #   b.scroll.to :bottom
    # end

    # # Scroll and click all 'load more' as long as there is one
    # while b.element(:class =>"badge-load-more-trigger").exists?
    #   b.links(:class => "badge-load-more-trigger")[0].click
    #   b.scroll.to :bottom
    #   sleep 0.25
    # end
    
    # Uncollaspe all replies
    # while b.element(:class => "collapsed-comment").exists? do
    #   b.links(:class => "collapsed-comment").each{|x|
    #     x.fire_event :click
    #     sleep 0.1
    #   }
    # end
    html = b.html
    headless.destroy
    current_page= Nokogiri::HTML(html)
    
    # setting Post attributes 
    @current_page = current_page
    @title = current_page.css("article header h2").text 
    @upvotes = current_page.css("article")[0]["data-entry-votes"]
    @nbComments = current_page.css("article")[0]["data-entry-comments"]
    @img = current_page.css("div.badge-post-container.badge-entry-content.post-container > a > div > img")[0]["src"]

    # Specific behavior for comments
    # see 'loadComments'
    
    loadComments
    self
  end

  def loadComments
    # Every comment is in a 'comment-entry' class element
    comments= @current_page.css(".badge-comment").drop 1
    comments.each{|x|
      c = Comment.new
      c.author = x.css(".username").text
      c.content = x.css(".content").text
      date=x.css(".badge-ago")[0]
      date=date.text
      date = date.gsub(/[dhms]/){|x|
        case x
        when "d"
          " days ago"
        when "h"
          " hours ago"
        when "m"
          " minutes ago"
        when "s"
          " seconds ago"
        end
      }
      date = "1 seconds ago" if date == "a moment ago."
      c.date=Chronic.parse(date).to_date
      @comments.push c
    }    
  end

  def to_json(*args)
    json = {:id => "#{@id}", :url => "#{@url}", :title => "#{title}", :upvotes => @upvotes.to_i, :img => "#{@img}", :nbComments => @nbComments.to_i, :comments => Array.new}
    comments = Array.new
    @comments.each{|x| comments.push(JSON.parse(x.to_json))}
    json[:comments] = comments
    JSON.generate(json)
  end

  private :loadComments
end
