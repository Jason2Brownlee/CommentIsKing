class DiscussionSummary
  
  
  attr_accessor :delicious_posts, :delicious_source,
    :total_digg, :digg_posts, :digg_comments, 
    :ff_posts, :ff_comments, :ff_source,
    :tweets, :tweets_source,
    :blog_comments, :blog_source,
    :reddit_posts, :reddit_comments, :total_reddit
    
    
    def calc_blog_comments(blog_comments)
      if blog_comments.blank?
        @blog_comments = 0
        @blog_source = nil
        return
      end
      @blog_comments = blog_comments.size
      @blog_source = blog_comments.first.feed_url
    end
    
    def calc_delicious_posts(delicious_posts)
      if delicious_posts.blank?
        @delicious_posts = 0
        @delicious_source = nil
        return
      end
      @delicious_posts = delicious_posts.size
      @delicious_source = delicious_posts.first.feed_source
    end
    
    def calc_tweets(tweets)
      if tweets.blank?
        @tweets = 0
        @tweets_source = nil
        return
      end
      @tweets = tweets.size
      @tweets_source = tweets.first.feed_source
    end
    
    def calc_friendfeed_posts(friendfeed_posts)
      if friendfeed_posts.blank?
        @ff_posts = 0
        @ff_comments = 0
        @ff_source = nil
        return
      end
      @ff_posts = friendfeed_posts.size
      @ff_comments = 0
      for ffc in friendfeed_posts
        @ff_comments += (ffc.ff_comments.nil?) ? 0 : ffc.ff_comments.size
      end
      @ff_source = friendfeed_posts.first.feed_source
    end
    
    
    def calc_digg_posts(digg_posts)
      if digg_posts.blank?
        @digg_posts = 0
        @digg_comments = 0
        @total_digg = 0
        return
      end      
      @digg_posts = digg_posts.size
      @digg_comments = 0
      @total_digg = 0
      for dp in digg_posts
        @digg_comments += (dp.comments.nil?) ? 0 : dp.comments.size
        # comments
        @total_digg = dp.num_comments
        # each post
        @total_digg += 1
      end

    end
    
    def calc_reddit_posts(reddit_posts)      
      if reddit_posts.blank?
        @reddit_posts = 0
        @reddit_comments = 0
        @total_reddit = 0
        return
      end      
      @reddit_posts = reddit_posts.size
      @reddit_comments = 0
      @total_reddit = 0
      reddit_posts.each do |post|      
        c = (post.comments.nil?) ? 0 : post.comments.size
        @reddit_comments += c
        # comments
        @total_reddit = c
        # each post
        @total_reddit += 1
      end
    end
    

   
    
    def total_ff
      return @ff_posts + @ff_comments
    end
end