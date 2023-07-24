require 'friend-feed'

class FriendFeedComment < Comment
  
  attr_accessor :ff_post
  
  
# background
# http://github.com/crnixon/ruby_friend-feed/tree/master
# http://code.google.com/p/friendfeed-api/wiki/ApiDocumentation
    
  def initialize(ff_post=nil)  
    @source_name = "FriendFeed"
    @ff_post = ff_post
  end
  
  
  def populate_from_api(api_item_obj)
    # easy stuff
    @title = nil
    @content = api_item_obj['body']
    @link = nil
    @date = Time.parse api_item_obj['date'].to_s

    # user
    @author = CommentAuthor.new
    @author.name = api_item_obj['user']['name']
    @author.nickname = api_item_obj['user']['nickname']
    @author.profile_url = api_item_obj['user']['profileUrl']
  end
  
  
end