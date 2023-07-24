require 'json'
# require 'json/ext'
# require 'json/pure'
# require 'json/add/rails'




# help:
# http://code.reddit.com/ticket/154


module Reddit
  
  # The list of submits found for an article.
  class InfoList < ResourceList
    

    def initialize(article_url)
      @article_url = article_url
      @url = INFO_URL.gsub('[id]', @article_url)
      # @redirect_location = nil
    end
    
    #  http://www.ruby-doc.org/stdlib/libdoc/net/http/rdoc/classes/Net/HTTP.html
    # def is_redirect_post?
    #   response = Net::HTTP.get_response(URI.parse(@url))
    #   puts "is_redirect_post? #{@url}"
    #   puts "response: #{response}"
    #   
    #   # if response == Net::HTTPRedirection
    #   # if response == Net::HTTPFound      
    #   if !response['location'].nil?
    #     @redirect_location = response['location']
    #     puts "redirect: #{@redirect_location}"
    #     return true
    #   end
    #   
    #  return false      
    # end
    
    # def get_comments
    #   return nil if @redirect_location.nil?
    #   
    #   article_url = @redirect_location.gsub('?already_submitted=true', '')
    #   resources = get_resources(article_url)
    #   
    #   comments = []
    #   resources.each do |comment|
    #     comments << Comment.new(comment['data'])
    #   end
    #   
    #   return comments
    # end
    
    



# ------ TESTING BELOW HERE

    # def comments
    #   resources = get_resources(@url)
    #   
    #   comments = []
    #   resources.each do |comment|
    #     comments << Comment.new(comment['data'])
    #   end
    #   
    #   return comments
    # end
    
    
    def self.diy(a_url)


      begin
        res = Net::HTTP.get_response(URI.parse(a_url))
      rescue
        return nil
      end

      
      raise SubredditNotFound if res.is_a?(Net::HTTPRedirection)
      
      resources = JSON.parse(res.body, :max_nesting => 0)
      
      # comments pages are contained in an array where the first element is the article
      # and the second is the actual comments.  This is hackish.
      resources = resources.last if resources.is_a?(Array)
      
      return resources['data']['children']      
    end
    
    def articles
      # resources = get_resources(@url)
      # puts "looking up: #{@url}"
      resources = InfoList.diy(@url)
      return nil if resources.nil?
      
      articles = []
      
      resources.each do |article|
        articles << Article.new(article['data'])
      end
      
      return articles
    end
    
    
    
    
    private
    
    # forward any method calls to the top level comments array.
    # def method_missing(meth, *args, &block)
    #   top_level.send(meth, *args, &block)
    # end    
  end
end