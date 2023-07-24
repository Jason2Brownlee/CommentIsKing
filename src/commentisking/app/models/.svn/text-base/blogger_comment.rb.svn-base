
require 'feed-normalizer'
require 'open-uri'

class BloggerComment < Comment

  attr_accessor :feed_url

  def initialize(feed_url)  
    @source_name = "Blogger"
    @feed_url = feed_url
  end
  
  def popular_from_api(api_item)
    # easy stuff
    @title = api_item.title
    @content = api_item.content
    @link = api_item.urls[0]
    # timestamp
    @date = Time.parse api_item.date_published.to_s

    # author
    @author = CommentAuthor.new    
    author_string = api_item.authors[0]
    # check for annon
    if author_string.nil? or !author_string.index('Anonymous').nil?
      @author.name = "Anonymous"
    elsif !(s_pos = author_string.index('http://')).nil?
      # extract user name    
      @author.name = author_string[0,s_pos]
      # extract profile address     
      @author.profile_url = author_string[s_pos, author_string.length]      
      # strip no email address
      if !(e_pos = @author.profile_url.index('noreply@blogger.com')).nil?
        # @author.profile_url = @author.profile_url[0, e_pos]
        # cannot access profile - so may as well not show url
        @author.profile_url = nil
      else 
         # TODO - there is an email on the end of this that needs to be stripped
      end
    else
      # could be some random text, or an email address
      @author.name = "Anonymous"
    end
    
  end
  
  def self.load_feed(atom_address)
    feed = nil
    begin
      #  deadly download and parse
      feed = FeedNormalizer::FeedNormalizer.parse open(atom_address)
    rescue
      feed = nil  
    end
    
    return feed
  end
  
  def self.load_blogger_comments_url(post)
    blog_comments_feed = nil
    
    return nil if post.doc.nil?
    
    # look for blogger comments
    (post.doc/"html/head/link").each do |link|
      if link.attributes['rel'] == "alternate"
        href = link.attributes['href']
        s_pos = href.rindex('/comments/default')
        if !s_pos.nil? and s_pos > 0
          blog_comments_feed = href
          break
        end
      end
    end
    
    return blog_comments_feed
  end
  
  
  def self.load_comment_feed(atom_address)
    # parse
    feed  = load_feed(atom_address)
    return feed
  end
  
  def self.load_comments(post)
    # locate atom feed
    atom_address = BloggerComment.load_blogger_comments_url(post)
    return nil if atom_address.nil?
    
    # download and parse the feed
    feed = BloggerComment.load_comment_feed(atom_address)
    return nil if feed.nil?
    
    comments = []
    
    #  process
    for item in feed.entries
      comment = BloggerComment.new(atom_address)
      comment.popular_from_api(item)
      comments << comment
    end
    
    return comments
  end
  
end