class DiggComment < Comment
  
  attr_accessor :digg_posts, :comment_id, :replies, :api_obj, :num_replies, :reply_obj
  
  def initialize(digg_post)  
    @source_name = "Digg"
    @digg_post = digg_post
    @replies = []
  end
  
  
  
  def populate_from_api(api_item_obj)
    # easy stuff
    @api_obj = api_item_obj
    @title = nil
    @content = api_item_obj.content
    @link = nil
    @date = Time.at api_item_obj.date.to_i

    # digg
    @num_replies = api_item_obj.replies.to_i
    @comment_id = api_item_obj.id

    # replies
    if !@digg_post.nil? and !@num_replies.nil? and @num_replies.to_i > 0
      replies_rs = DiggComment.locate_replies(@digg_post.digg_id, @comment_id)
      @reply_obj = replies_rs
      if !replies_rs.blank?
        if !replies_rs.instance_of?(Array)
          reply = DiggComment.new(@digg_post)
          reply.populate_from_api(replies_rs)
          @replies << reply        
        else
          replies_rs.each do |reply_rs|
            reply = DiggComment.new(@digg_post)
            reply.populate_from_api(reply_rs)
            @replies << reply
          end
          # order
          @replies = @replies.sort_by {|u| u.date}
        end
      end
    end

    # user
    @author = CommentAuthor.new
    @author.name = api_item_obj.user
  end
  
  def self.locate_replies(story_id, comment_id)   
    diggr = Diggr::API.new
    digg_replies_rs = nil
    
    begin
      digg_replies_rs = diggr.story(story_id).comment(comment_id).replies.options(:count=>100,:offset=>0).fetch
    rescue
      digg_replies_rs = nil
    end
    
    return digg_replies_rs
  end
  
end