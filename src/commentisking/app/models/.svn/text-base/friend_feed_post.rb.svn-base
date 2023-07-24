require 'friend-feed'


require 'cgi'

class FriendFeedPost < Comment
  
# background
# http://github.com/crnixon/ruby_friend-feed/tree/master
# http://code.google.com/p/friendfeed-api/wiki/ApiDocumentation
  
  attr_accessor :ff_source_name, :ff_source_url, :ff_source_icon, 
    :ff_comments, :feed_source
  
  def initialize(feed_source)  
    @source_name = "FriendFeedPost"
    @feed_source = feed_source
    @ff_comments = []
  end
  
  
  def popular_from_api(api_item_obj)
    # easy stuff
    @title = api_item_obj['title']
    @link = api_item_obj['link']
    @date = Time.parse api_item_obj['published'].to_s
    
    # ff
    @ff_source_name = api_item_obj['service']['name']
    @ff_source_url = api_item_obj['service']['profileUrl']
    @ff_source_icon = api_item_obj['service']['iconUrl']
    # ff comments
    for ff_c in api_item_obj['comments']
      comment = FriendFeedComment.new(self)
      comment.populate_from_api(ff_c)
      @ff_comments << comment
    end
    
    if !@ff_comments.nil? and !@ff_comments.empty?
      @ff_comments = @ff_comments.sort_by {|u| u.date}
    end
    
    # user
    @author = CommentAuthor.new
    @author.name = api_item_obj['user']['name']
    @author.nickname = api_item_obj['user']['nickname']
    @author.profile_url = api_item_obj['user']['profileUrl']
  end
  
  
  def self.friendfeed_search(search_term)
    # 
    # TDDO - this unescape function doesn't do it all - weak
    # 
    # attempt to unescape
    search_term = CGI.unescapeHTML(search_term)
    # quote it
    search_term = "\"#{search_term}\""  
    # username and api_key not needed for non-auth-required actions
    ff_api = FriendFeed::Client.new    
    ff_results = ff_api.search(search_term, {:num=>100, :start=>0})
    return ff_results
  end
  
  # 
  # I cheat here by searching for the exact text in the page title
  # 
  def self.friend_feed_api_posts(address, page_title)
    #  must have something to search for
    return nil if page_title.nil?
    
    # perform a search
    ff_results = FriendFeedPost.friendfeed_search(page_title)
    
    # TODO: not sure about the rs array situation: ff_results.entries.first[1]
    # could there be multiple entries?    
    posts = []    
    for item in ff_results.entries.first[1]
      post = FriendFeedPost.new(FriendFeedPost.source_feed_calc(page_title))
      post.popular_from_api(item)
      posts << post
    end
    
    return posts    
  end
  
  
  def self.source_feed_calc(term)
    data = ''
    data += 'http://friendfeed.com/search?q=%22'
    data += term
    data += '%22&service=&public=1&who=&format=atom'
    return data
  end
  
end