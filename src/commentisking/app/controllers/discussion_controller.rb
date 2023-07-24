class DiscussionController < ApplicationController

  def show
    # lookup
    @submission = Submission.find(params[:id])
    # prep
    @submission.prepare
    data_prep
  end
  
  def data_prep
    # fetch conversations from API's
    digg_magic(@submission.address)
    reddit_magic(@submission.address)
    delicious_magic(@submission.address)
    friendfeed_magic(@submission.address, @submission.post_title)
    twitter_magic(@submission)
    blog_comments(@submission)    
    # summary
    summary_magic
    # aggregatge
    feed_magic
    # graph
    graph_magic
  end
  
  
  
  private
  
  
  # http://github.com/peterpunk/open_flash_chart_lazy/tree/master
  def generate_graph_json
    return if @feed.nil? or @feed.empty?
    # adaptive range
    range_seconds = (@feed.last.date - @feed.first.date)
    @graph_data_divisor = (range_seconds / 50)
    
    
    dot_size = 5
    y_axis_labels = []
    y_axis_labels << ""
    
   data = '{"elements": ['
   series = []
  
   x_min = 1.0/0.0
   x_max = -x_min
   y_axis = 0
     
   if !@blog_comments.blank?
       data_tmp = ''
       y_axis_labels << "Comments"
       data_tmp
       data_tmp += ' {"type": "scatter", "colour": "#8f7147", "dot-size": '
       data_tmp += dot_size.to_s
       data_tmp += ', "values": [ '
       y_axis += 1
       #  process comments
       comment_data = []
       @blog_comments.each do |comment|
         # hours ago
         hours_ago = time_diff(comment.date)
         # update bounds
         x_min = hours_ago if hours_ago < x_min
         x_max = hours_ago if hours_ago > x_max       
         # add the data
         comment_data << generate_json_coord(hours_ago, y_axis)
       end     
       # all data
       data_tmp += comment_data.join(', ')
       # cap the series
       data_tmp += ' ] }'
       series << data_tmp
     end
     
     if !@twitter_comments.blank?
       data_tmp = ''
       y_axis_labels << "Twitter"
       data_tmp += ' {"type": "scatter", "colour": "#6fe1e6", "dot-size": '
        data_tmp += dot_size.to_s
        data_tmp += ', "values": [ '
       y_axis += 1
       #  process comments
       comment_data = []
       @twitter_comments.each do |comment|
         # hours ago
         hours_ago = time_diff(comment.date)
         # update bounds
         x_min = hours_ago if hours_ago < x_min
         x_max = hours_ago if hours_ago > x_max       
         # add the data
         comment_data << generate_json_coord(hours_ago, y_axis)
       end     
       # all data
       data_tmp += comment_data.join(', ')
       # cap the series
       data_tmp += ' ] } '
       series << data_tmp
    end
    
     if !@delicious_comments.blank?
       data_tmp = ''
       y_axis_labels << "Delicious"
       data_tmp += ' {"type": "scatter", "colour": "#3247d0", "dot-size": '
        data_tmp += dot_size.to_s
        data_tmp += ', "values": [ '
       y_axis += 1
       #  process comments
       comment_data = []
       @delicious_comments.each do |comment|
         # hours ago
         hours_ago = time_diff(comment.date)
         # update bounds
         x_min = hours_ago if hours_ago < x_min
         x_max = hours_ago if hours_ago > x_max       
         # add the data
         comment_data << generate_json_coord(hours_ago, y_axis)
       end     
       # all data
       data_tmp += comment_data.join(', ')
       # cap the series
       data_tmp += ' ] } '
       series << data_tmp
    end
    
     if !@friendfeed_posts.blank?
       data_tmp = ''
       y_axis_labels << "FriendFeed"
       data_tmp += ' {"type": "scatter", "colour": "#9dbee8", "dot-size": '
        data_tmp += dot_size.to_s
        data_tmp += ', "values": [ '
       y_axis += 1
       #  process comments
       comment_data = []
       @friendfeed_posts.each do |comment|
         # hours ago
         hours_ago = time_diff(comment.date)
         # update bounds
         x_min = hours_ago if hours_ago < x_min
         x_max = hours_ago if hours_ago > x_max
         # add the data
         comment_data << generate_json_coord(hours_ago, y_axis)
         if !comment.ff_comments.nil?
           comment.ff_comments.each do |c|
             # hours ago
             hours_ago = time_diff(c.date)
             # update bounds
             x_min = hours_ago if hours_ago < x_min
             x_max = hours_ago if hours_ago > x_max
             # add the data
             comment_data << generate_json_coord(hours_ago, y_axis)
          end
         end         
       end     
       # all data
       data_tmp += comment_data.join(', ')
       # cap the series
       data_tmp += ' ] } '
       series << data_tmp
    end
    
     if !@digg_posts.blank?
       data_tmp = ''
       y_axis_labels << "Digg"
       data_tmp += ' {"type": "scatter", "colour": "#1b5790", "dot-size": '
        data_tmp += dot_size.to_s
        data_tmp += ', "values": [ '
       y_axis += 1
       #  process comments
       comment_data = []
       @digg_posts.each do |comment|
         # hours ago
         hours_ago = time_diff(comment.date)
         # update bounds
         x_min = hours_ago if hours_ago < x_min
         x_max = hours_ago if hours_ago > x_max
         # add the data
         comment_data << generate_json_coord(hours_ago, y_axis)
         if !comment.comments.nil?
           comment.comments.each do |c|
             # hours ago
             hours_ago = time_diff(c.date)
             # update bounds
             x_min = hours_ago if hours_ago < x_min
             x_max = hours_ago if hours_ago > x_max
             # add the data
             comment_data << generate_json_coord(hours_ago, y_axis)
          end
         end
       end     
       # all data
       data_tmp += comment_data.join(', ')
       # cap the series
       data_tmp += ' ] } '
       series << data_tmp
    end
    
     if !@reddit_posts.blank?
       data_tmp = ''
       y_axis_labels << "Reddit"
       data_tmp += ' {"type": "scatter", "colour": "#1b5790", "dot-size": '
        data_tmp += dot_size.to_s
        data_tmp += ', "values": [ '
       y_axis += 1
       #  process comments
       comment_data = []
       @reddit_posts.each do |comment|
         # hours ago
         hours_ago = time_diff(comment.date)
         # update bounds
         x_min = hours_ago if hours_ago < x_min
         x_max = hours_ago if hours_ago > x_max
         # add the data
         comment_data << generate_json_coord(hours_ago, y_axis)
         if !comment.comments.nil?
           comment.comments.each do |c|
             # hours ago
             hours_ago = time_diff(c.date)
             # update bounds
             x_min = hours_ago if hours_ago < x_min
             x_max = hours_ago if hours_ago > x_max
             # add the data
             comment_data << generate_json_coord(hours_ago, y_axis)
          end
         end
       end     
       # all data
       data_tmp += comment_data.join(', ')
       # cap the series
       data_tmp += ' ] } '
       series << data_tmp
    end

    data += series.join(', ')
    
    # build labels
    y_axis_labels << ""
    y_axis_labels_s = "\"#{y_axis_labels.join("\", \"")}\""

  
    # finish elements
    data += ' ], '
    # general graph data
    data += '"bg_colour": "#FFFFFF", "x_axis": { "min": '    
    data += x_min.to_s
    data += ', "max": '
    data += (x_max+1).to_s
    data += ', "grid-colour": "#ffffff", "colour": "#dddddd" }, "y_axis": { "min": 0, "max": '
    data += (y_axis + 1).to_s
    data += ', "grid-colour": "#eeeeee", "colour": "#dddddd", "labels": [ '
    data += y_axis_labels_s
    data += ' ] } }'
        
    return data
  end
  

  def generate_json_coord(x, y)
    comment_data_raw = ""
    comment_data_raw += ' { "x": "'
    comment_data_raw += x.to_s
    comment_data_raw += '" , "y": "'
    comment_data_raw += y.to_s
    comment_data_raw += '" }'
    return comment_data_raw
  end
  
  def time_diff (time)
    diff_seconds = (Time.now - time)        
    bin = diff_seconds.to_f /  @graph_data_divisor.to_f
    # return bin.to_i
    return 50 - bin
  end




  # --- proxy calls (for now)
  
  def graph_magic
    @graph_json = generate_graph_json
  end
  
  def feed_magic
    @feed = []
    
    # digg
    if !@digg_posts.nil?
      add_to_feed(@digg_posts)
      for dp in @digg_posts
        add_to_feed(dp.comments)
      end
    end
    
    # reddit
    if !@reddit_posts.nil?
      add_to_feed(@reddit_posts)
      for rp in @reddit_posts
        add_to_feed(rp.comments)
      end
    end
    
    # friend feed
    add_to_feed(@friendfeed_posts)    
    # delicious
    add_to_feed(@delicious_comments)
    # tweets
    add_to_feed(@twitter_comments)
    # blog
    add_to_feed(@blog_comments)
    
    # sort ASC
    @feed = @feed.sort_by {|u| u.date}
  end
  
  
  def add_to_feed(comment_list)
    return if comment_list.nil?
    return if comment_list.empty?
    
    comment_list.each do |comment|
      @feed << comment
    end
  end
  
  
  def summary_magic
    # summary
    @summary = DiscussionSummary.new
    # digg
    @summary.calc_digg_posts(@digg_posts)
    # reddit
    @summary.calc_reddit_posts(@reddit_posts)
    # ff
    @summary.calc_friendfeed_posts(@friendfeed_posts)
    # tweets
    @summary.calc_tweets(@twitter_comments)
    # blogs
    @summary.calc_blog_comments(@blog_comments)
    # delicious
    @summary.calc_delicious_posts(@delicious_comments)
  end
  

  

  
  def digg_magic(address)
    @digg_posts = DiggPost.api_digg_story(address)
  end
  
  def reddit_magic(address)
    @reddit_posts = RedditPost.reddit_posts_for_address(address)
  end
  
  def delicious_magic(address)
    @delicious_comments = DeliciousComment.map_rss_comments(address)
  end
  
  def friendfeed_magic(address, page_title)    
    @friendfeed_posts = FriendFeedPost.friend_feed_api_posts(address, page_title)
  end
  
  def twitter_magic(post)
    @twitter_comments = []
    @twitter_comments += TwitterComment.twitter_comments_by_tinyurl(post.address)
  end
  
  def blog_comments(post)    
    @blog_comments = WordpressComment.load_comments(post) || BloggerComment.load_comments(post)    
  end
  
end
