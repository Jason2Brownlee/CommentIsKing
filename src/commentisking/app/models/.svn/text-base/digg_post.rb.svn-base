require 'diggr'


class DiggPost < Comment
  
  attr_accessor :num_diggs, :topic, :comments, :digg_id, :api_obj, :num_comments
  
  def initialize()  
    @source_name = "Digg"
    @comments = []
  end
  

  def populate_from_api(api_item_obj)
    # easy stuff    
    @title = api_item_obj.title
    @content = api_item_obj.description
    @link = api_item_obj.href
    @date = Time.at api_item_obj.submit_date.to_i

    # digg
    @num_diggs = api_item_obj.diggs
    @topic = api_item_obj.topic.name
    @digg_id = api_item_obj.id
    @num_comments = api_item_obj.comments.to_i
    @api_obj = api_item_obj

    # user    
    @author = CommentAuthor.new
    @author.name = api_item_obj.user.name
    @author.image_url = api_item_obj.user.icon
  end


  # diggr API wrapper
  # http://github.com/dfg59/diggr/tree/master
  # http://diggr.rubyforge.org/
  # all digg end points http://apidoc.digg.com/CompleteList  
  # wiki entry re pagination: http://apidoc.digg.com/ListEvents
  def self.locate_story(address)
    diggr = Diggr::API.new    
    digg_story_rs = nil
    
    # grab the story
    begin
      digg_story_rs = diggr.stories.options(:link=>address).fetch
    rescue
      digg_story_rs = nil
    end
    
    return digg_story_rs
  end
  
  def self.locate_comments(digg_story_id, offset=0)   
    diggr = Diggr::API.new
    digg_comments_rs = nil
    
    begin
      # grab the story
      story = diggr.story(digg_story_id)
      digg_comments_rs = story.comments.options(:count=>100,:offset=>offset).fetch
    rescue
      digg_comments_rs = nil
    end
    
    return digg_comments_rs
  end
  

  def self.api_digg_story(address)
    # perform the lookup
    digg_story_rs = DiggPost.locate_story(address) 
    return nil if digg_story_rs.blank?
    
    # could be multiple stories
    stories = []
    
    # hack for single story case
    if !digg_story_rs.instance_of?(Array)
      # build a story
      story = DiggPost.digg_story_factory(digg_story_rs)
      # add to list
      stories << story
    else
      # process the list of stories
      for story_rs in digg_story_rs
        # build a story
        story = DiggPost.digg_story_factory(story_rs)
        # add to list
        stories << story
      end
    end
        
    return stories
  end
  
  def self.digg_story_factory(story_rs)
    #  populate story
    story = DiggPost.new
    story.populate_from_api(story_rs)
    
    if story.num_comments.to_i > 0
      # paginate comments
      while story.comments.size < story.num_comments
        # grab all comments
        digg_comments_rs = DiggPost.locate_comments(story.digg_id, story.comments.size)
        break if digg_comments_rs.blank?
        # process
        if digg_comments_rs.instance_of?(Array)
          #  process comments
          digg_comments_rs.each do |comment_rs|
            digg_comment = DiggComment.new(story)
            digg_comment.populate_from_api(comment_rs)
            story.comments << digg_comment
          end
        else
          digg_comment = DiggComment.new(story)
          digg_comment.populate_from_api(digg_comments_rs)
          story.comments << digg_comment
        end
      end
    end
    
    return story
  end
  
end