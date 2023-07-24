require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

class DeliciousComment < Comment

# background
# api: http://www.programmableweb.com/api/del.icio.us
# roundup: http://blogs.law.harvard.edu/hoanga/2008/04/07/a-quick-survey-of-delicious-apis-for-ruby/

# GREAT:
# Officual: http://delicious.com/help/json/


  attr_accessor :tags, :feed_source

  def initialize(feed_source)  
    @source_name = "Delicious"
    @feed_source = feed_source
    @tags = []
  end
  
  def popular_from_api(rss_item_obj)
    # easy stuff
    @title = rss_item_obj.title
    @content = rss_item_obj.description
    @link = rss_item_obj.link
    @date = Time.parse rss_item_obj.date.to_s
    #  tags
    for category in rss_item_obj.categories
      @tags << category.content
    end
    # user
    @author = CommentAuthor.new
    @author.name = rss_item_obj.source.content
    @author.profile_url = rss_item_obj.source.url
  end
  
  
  # mapping RSS comments onto DeliciousComment
  def self.map_rss_comments(address)
    rss = DeliciousComment.rss_comments_for_url(address)
    return if rss.nil?
    
    comments = []    
    for item in rss.items
      comment = DeliciousComment.new(address)
      comment.popular_from_api(item)
      comments << comment
    end
    
    return comments
  end
  
  
  
  def self.delicious_lookup_id(address)
    # prep
    delicious_url_base = "http://delicious.com/url/view?url=[id]"
    delicious_url = delicious_url_base.gsub('[id]', address)
    
    begin
      # make the request
      response = Net::HTTP.get_response(URI.parse(delicious_url)) 
    rescue
      return nil
    end
    
    #  process the response
    case response
        when Net::HTTPRedirection
          # ok
        else
          # res.error!
          return nil
        end
        
    # retrieve the redirect
    redirect_url = response['location']    
    return nil if redirect_url.blank?
    # extract the post id
    s_pos = redirect_url.rindex('/') 
    return nil if s_pos.nil? or s_pos<0    
    post_id = redirect_url[s_pos + 1, redirect_url.length]
  end
  
  # JB - DIY hack to get delicious comments for URL
  def self.rss_comments_for_url(address)
    
    # get the id
    post_id = DeliciousComment.delicious_lookup_id(address)
    return nil if post_id.nil?

    # prep the rss
    delicious_feed_base = "http://feeds.delicious.com/v2/rss/url/[id]?count=100"
    delicious_feed = delicious_feed_base.gsub('[id]', post_id)    
    # download the rss
    rss = nil
    begin
      content = "" # raw content of rss feed will be loaded here
      open(delicious_feed) do |s| content = s.read end
      # parse
      rss = RSS::Parser.parse(content, false)
    rescue 
      rss = nil
    end
    return rss
  end

end