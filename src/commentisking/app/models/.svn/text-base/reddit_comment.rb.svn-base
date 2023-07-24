class RedditComment < Comment
  
  attr_accessor :reddit_post, :replies, :reddit_post_id, :downs
  
  def initialize(reddit_post)  
    @source_name = "Reddit"
    @reddit_post = reddit_post
    @replies = []
  end
  
  def populate_from_api(api_item_obj)
    # easy stuff
    @title = nil
    @content = api_item_obj.body
    @link = api_item_obj.url
    @date = Time.parse api_item_obj.created_at.to_s

    # reddit
    @reddit_post_id = api_item_obj.id
    @downs = api_item_obj.downs
    #  TODO - num comments

    # user
    @author = CommentAuthor.new
    if not api_item_obj.author.nil?
      @author.name = api_item_obj.author.name
      @author.profile_url = api_item_obj.author.url
    end
    
    # replies
    for reply_rs in api_item_obj.replies
      reply = RedditComment.new(@reddit_post)
      reply.populate_from_api(reply_rs)
      @replies << reply
    end
  end
  
end