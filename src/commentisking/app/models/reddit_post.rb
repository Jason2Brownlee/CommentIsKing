require 'reddit'

# http://www.reddit.com/comments/6kg9c/reddit_api_wrapper_written_in_ruby_and_packed_as
# http://github.com/bterlson/reddit/tree/master

class RedditPost < Comment
  
  attr_accessor :comments, :ups, :downs, :reddit_post_id
  
  def initialize(base_article)  
    @source_name = "RedditPost"
    @comments = []
    populate_from_api(base_article)
  end
  
  def populate_from_api(api_item_obj)
    # easy stuff
    @title = api_item_obj.title
    @content = nil
    @link = api_item_obj.url
    @date = Time.parse api_item_obj.created_at.to_s

    # reddit
    @ups = api_item_obj.ups
    @downs = api_item_obj.downs
    @reddit_post_id = api_item_obj.id

    # user
    @author = CommentAuthor.new
    @author.name = api_item_obj.author.name
    @author.profile_url = api_item_obj.author.url
    
    # comments
    populate_comments
  end
  
  
  def populate_comments
    #  retrieve the comments
    comments_rs = RedditPost.retrieve_comments(@reddit_post_id)
    # process comments
    comments_rs.each do |c|
      comment = RedditComment.new(self)
      comment.populate_from_api(c)
      @comments << comment
    end
  end
  
  
  def self.retrieve_comments(article_id)
    Reddit::CommentList.new(article_id)
  rescue
    return nil
  end
  
  def self.retrieve_articles(address)
    Reddit::InfoList.new(address).articles
  rescue
    return nil
  end
  
  def self.reddit_posts_for_address(address)    
    articles = RedditPost.retrieve_articles(address)
    articles.collect do |article|
      RedditPost.new(article)      
    end
  end
    
end