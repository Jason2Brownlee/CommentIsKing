require 'twitter'

class TwitterComment < Comment
  
  attr_accessor :tiny_url, :feed_source


# background
# SEMINAL: http://search.twitter.com/api
# http://twitter.rubyforge.org/


  def initialize(feed_source, tiny_url="")  
    @source_name = "Twitter"
    @tiny_url = tiny_url
    @feed_source = feed_source
  end
  
  def popular_from_api(rss_item_obj)
    # easy stuff
    # @title = rss_item_obj.title
    @content = rss_item_obj['text']
    @link = rss_item_obj['link']
    tmp_date = rss_item_obj['created_at']
    @date = Time.parse tmp_date.to_s
    
    # TODO: not handeling "to user" or anything 

    # user
    @author = CommentAuthor.new
    @author.name = rss_item_obj['from_user']
    @author.image_url = rss_item_obj['profile_image_url']
  end
  
  
  # a twitter search
  def self.twitter_search(term)
    twitter_posts = nil
    begin
      twitter_posts = Twitter::Search.new(term)
    rescue 
      twitter_posts = nil
    end
    return twitter_posts
  end
  
  
  def self.twitter_comments_by_title(page_title)
    # search twitter
    twitter_posts = twitter_search(page_title)
    return if twitter_posts.blank?
        
    comments = []    
    for item in twitter_posts
      comment = TwitterComment.new(TwitterComment.source_feed_calc(page_title))
      comment.popular_from_api(item)
      comments << comment
    end
    
    return comments    
  end
  
  def self.source_feed_calc(term)
    data= 'http://search.twitter.com/search.atom?q='
    data +=term
    return data
  end
  

  def self.twitter_comments_by_tinyurl(address)
    # get the tiny url for the post
    tiny_url = TwitterComment.tiny_url(address)
    return nil if tiny_url.nil?
   
    # search twitter
    twitter_posts = twitter_search(tiny_url)
    return if twitter_posts.blank?
    
    comments = []    
    for item in twitter_posts
      comment = TwitterComment.new(TwitterComment.source_feed_calc(tiny_url), tiny_url)
      comment.popular_from_api(item)
      comments << comment
    end
    
    return comments    
  end
  
  # tiny url api hacking
  def self.tiny_url(address)
    base = "http://tinyurl.com/api-create.php?url=[id]"
    url_location = base.gsub('[id]', address)
    tiny_url_response = Net::HTTP.get_response(URI.parse(url_location)) 
    tiny_url = nil
    
    case tiny_url_response
        when Net::HTTPSuccess
          tiny_url = tiny_url_response.body
        else    
          tiny_url = nil
        end  
        
      return tiny_url      
  end
  
  
end