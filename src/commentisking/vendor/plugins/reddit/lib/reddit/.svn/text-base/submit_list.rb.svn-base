module Reddit
  
  # The list of submits found for an article.
  class SubmitList < ResourceList
    

    def initialize(article_url)
      @article_url = article_url
      @url = SUBMIT_URL.gsub('[id]', @article_url)
      @redirect_location = nil
    end
    

    #  http://www.ruby-doc.org/stdlib/libdoc/net/http/rdoc/classes/Net/HTTP.html
    def is_redirect_post?
      
      response = Net::HTTP.get_response(URI.parse(@url))
      puts "is_redirect_post? #{@url}"
      puts "response: #{response}"
      
      # if response == Net::HTTPRedirection
      # if response == Net::HTTPFound      
      if !response['location'].nil?
        @redirect_location = response['location']
        puts "redirect: #{@redirect_location}"
        return true
      end
      
     return false      
    end

    def get_comments
      return if @redirect_location.nil?
      
      article_url = @redirect_location.gsub('?already_submitted=true', '')
      resources = get_resources(article_url)
      
      comments = []
      resources.each do |comment|
        comments << Comment.new(comment['data'])
      end
      
      return comments
    end
    
    



# ------ TESTING BELOW HERE

    def comments
      resources = get_resources(@url)
      
      comments = []
      resources.each do |comment|
        comments << Comment.new(comment['data'])
      end
      
      return comments
    end
    
    
    def articles
      resources = get_resources(@url)
      
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