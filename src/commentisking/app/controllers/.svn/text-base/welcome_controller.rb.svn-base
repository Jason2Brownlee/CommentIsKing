class WelcomeController < ApplicationController
  
  
  def index
    @submission = Submission.new
    @recent_submissions = Submission.recent.find(:all, :limit=>10)
  end


  def submit
    if request.post?
      # prep
      @submission = Submission.new(params[:submission])
      # lookup
      @sub = Submission.find_by_address(@submission.address)
      if !@sub.nil?
        redirect_to discussion_path(@sub)
      else
        # save
        if @submission.save
          redirect_to discussion_path(@submission)
        else
          flash[:notice] = 'Sorry, your address is not quite right'
          @recent_submissions = Submission.recent.find(:all, :limit=>10)
          render :action=>"index"
        end
      end
    else
      redirect_to :action=>"index"
    end
  end
  

end
