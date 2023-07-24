
require 'feed-normalizer'
require 'open-uri'

class WordpressComment < Comment
  
  attr_accessor :feed_url

  def initialize(feed_url)  
    @source_name = "Wordpress"
    @feed_url = feed_url
  end
  
  def popular_from_api(api_item)
    # easy stuff
    @title = api_item.title
    @content = api_item.content
    @link = api_item.urls[0]
    # @date = api_item.date_published
    @date = Time.parse(api_item.date_published.to_s)

    # user
    author_string = api_item.authors[0]
    if !author_string.nil? 
      @author = CommentAuthor.new
      @author.name = author_string
      @author.image_url = nil
    end
  end
  
  def self.load_feed(feed_address)
    feed = nil
    
    begin
      #  deadly download and parse
      feed = FeedNormalizer::FeedNormalizer.parse open(feed_address)      
    rescue 
      feed = nil
    end
    
    return feed
  end
  
  
  #  basicall /feed on wordpress blogs works a treat
  def self.load_wordpress_comments_url(post)
    s_pos = post.address.rindex('/')
    if !s_pos.nil? and s_pos == (post.address.length - 1) 
      return "#{post.address}feed"
    end
    
    return "#{post.address}/feed"
  end
  
  def self.load_comments(post)
    # calculate the address
    address = load_wordpress_comments_url(post)
    return if address.nil?
    
    #  parse
    feed  = load_feed(address)
    return if feed.nil?
    
    comments = []
    
    #  process
    for item in feed.entries
      comment = WordpressComment.new(address)
      comment.popular_from_api(item)
      comments << comment
    end
    
    return comments
  end
  
end