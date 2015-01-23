class ApplicationController < ActionController::Base
    protect_from_forgery

    before_filter :ref_to_cookie, :setting_launch_time

    def mobile_device?
        if session[:mobile_param]
            session[:mobile_param] == "1"
        else
            request.user_agent =~ /Mobile|webOS/
        end
    end

    protected

    def setting_launch_time
        launch_time = AdminUser.first.created_at + 7.days
        launch_time = launch_time.to_time.to_i
        now_time = Time.now.to_time.to_i
        @remainning_time = launch_time - now_time
    end

    def ref_to_cookie

        if params[:ref] && !Rails.application.config.ended
            if !User.find_by_referral_code(params[:ref]).nil?
                #binding.pry
                cookies[:h_ref] = { :value => params[:ref], :expires => 1.week.from_now }
            end

            if request.env["HTTP_USER_AGENT"] and !request.env["HTTP_USER_AGENT"].include?("facebookexternalhit/1.1")
                redirect_to proc { url_for(params.except(:ref)) }  
            end
        end
    end

  def initialize    
    super # this calls ActionController::Base initialize
    #beginning_backgroundjob
  end


  private

  def beginning_backgroundjob

    # binding.pry
    
    if $flag
        return
    end
    $flag = true
    puts '******************************************starting background job&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'
    self.delay.send_notify_email
    
  end
end
