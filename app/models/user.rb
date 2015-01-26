
# include Rails.application.routes.url_helpers
require 'mandrill'  

class User < ActiveRecord::Base
    belongs_to :referrer, :class_name => "User", :foreign_key => "referrer_id"
    has_many :referrals, :class_name => "User", :foreign_key => "referrer_id"
    
    attr_accessible :email

    validates :email, :uniqueness => true, :format => { :with => /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i, :message => "Invalid email format." }
    validates :referral_code, :uniqueness => true

    before_create :create_referral_code
    after_create :send_sign_up_email, :add_subscribe_to_list_mailchimp

    REFERRAL_STEPS = [
        {
            'count' => 5,
            "html" => "Travel<br>Shower Kit",
            "class" => "two",
            # "image" =>  ActionController::Base.helpers.asset_path("refer/cream-tooltip@2x.png")
            "image" =>  ActionController::Base.helpers.asset_path("refer/level-1.jpg")
        },
        {
            'count' => 10,
            "html" => "Styling<br>Product",
            "class" => "three",
            # "image" => ActionController::Base.helpers.asset_path("refer/truman@2x.png")
            "image" => ActionController::Base.helpers.asset_path("refer/level-2.jpg")
        },
        {
            'count' => 25,
            "html" => "Complete<br>Kit",
            "class" => "four",
            # "image" => ActionController::Base.helpers.asset_path("refer/winston@2x.png")
            "image" => ActionController::Base.helpers.asset_path("refer/level-3.jpg")
        },
        {
            'count' => 50,
            "html" => "$100 Mister Pompadour<br>Gift Certificate",
            "class" => "five",
            # "image" => ActionController::Base.helpers.asset_path("refer/blade-explain@2x.png")
            "image" => ActionController::Base.helpers.asset_path("refer/level-4.jpg")
        }
    ]
    
    public 
    
    def update_list_mailchimp
        if Rails.env.production?
            gb = Gibbon::API.new(ENV['MAILCHIMP_KEY'])
            gb.lists.batch_subscribe(:id => ENV['MAILCHIMP_LIST_ID'], :batch => 
                [ {:email => {:email => self.email }, :merge_vars => { :RNUM => self.referrals.count}}], :update_existing => true)
        end
        
    end

    def send_sign_up_email
        root_url = "http://mister-pompadour-referral.herokuapp.com/"
        image = CGI::escape(root_url + '/assets/refer/logo-fb69ee306dd1e2eb28dd2e5c9e0c103d.jpg');
        title = CGI::escape('Mister Pompadour');
        url = CGI::escape(root_url);
        twitter_message = CGI::escape("#MisterPompadour #looksharpbeconfident Excited for @mistrpompadour new website launch.")
        referral_code = CGI::escape(self.referral_code);
        subject = "Welcome Email"

        html_content = '<!DOCTYPE html>
                          <html lang="en">
                          <head>
                            <meta charset="utf-8">
                            <title>Welcome</title>
                          </head>
                          <body style="margin: 0 auto;
                                  width: 940px;
                                  text-align: center;
                                  font-family: Arial;
                                  font-size: 25px;">

                            <div style="margin: 20px 0 0 0;text-align:left; float:left;">
                              <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_logo.jpg">
                            </div>

                            <div style="font-size: 34px;
                                  margin: 20px 0 0 20px; float:left; color: #16355D;">
                              <p style="margin: 10px 0 0; text-align: left;">
                                Welcome to the <i>Friend Referral Campaign...</i>
                              </p>
                              <p style="font-weight: bold;text-align:left; margin: 5px 0 0;">Let the Sharing Begin!</p>  
                              <hr style="font-size: 15px; width: 790px;" />
                            </div>

                            <div style="clear: both;"></div>
                            <div style="text-align: left;">
                              <p style="margin: 30px 0 0 0; color: #355F91;"><i>The more friends you refer = the more <b>FREE</b> product you earn! <b>Simple</b>.</i></p>
                            </div>

                            <div style="margin: 15px 0 0 0;">
                              <p style="color: #4F81BC;">Your Unique Referral Code</p>
                            </div>
                            <div style="background-color: #F1F0EE; width: 550px; margin: 7px auto; padding: 25px 50px;">
                              <div style="border: 1px solid #D1D0C7; background: #FFF; padding: 10px 0; font-size: 11px;">'
        html_content += root_url
        html_content += '?ref='
        html_content += self.referral_code
        html_content += '</div>
                          <div style="width: 120px; height:37px; margin: 25px auto 0; text-aling: center;">
                            <a href="http://www.facebook.com/sharer.php?u='
        html_content += url
        html_content += '?ref='
        html_content += referral_code
        html_content += '&p[title]='
        html_content += title
        html_content += '&p[images][0]='
        html_content += image
        html_content += '" target="_blank" style="background: url(http://mister-pompadour-referral.herokuapp.com/assets/refer/fb.png); background-size: 27px 27px; width:27px; height: 27px; display: inline-block;"></a>
                          <div style="height: 28px; width: 1px; background: #bab9ba; margin: 0 20px; display: inline-block;"></div>
                          <a href="http://twitter.com/share?url='
        html_content += url
        html_content += '?ref='
        html_content += referral_code
        html_content += '&text='
        html_content += twitter_message
        html_content += ''

        html_content += '" target="_blank" style="background: url(http://mister-pompadour-referral.herokuapp.com/assets/refer/twit.png); background-size: 27px 27px; width:27px; height: 27px; display: inline-block;"></a>
                            </div>  
                          </div>
                          <div style="margin-top: 20px;">
                            <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_1.jpg">
                          </div>

                          <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">Each friend can only be referred once so make sure you reach them
                            <i><b><span style="font-size: 30px;">before others do!</span></b></i></p>
                          
                          <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">This Friend Referral Campaign will only be available Feb. 1-8. Then it is 
                            <i><b><span style="font-size: 30px;">gone forever!</span></b></i></p>
                          <div style="background-color: #233E5F;margin: 40px auto; width: 650px;">
                            <p style="padding: 17px 20px;text-font: 35px; color: white;">LOOK SHARP. BE CONFIDENT.</p>
                          </div>
                          <div style="text-align: left;">
                            <p style="font-size: 17px; text-algin: left;"><i>copyright&#0169; 2015 Mister Pompadaur, LLC, All rights reserved.</i></p>
                          </div>
                          
                          <div style="text-align: left; font-size: 16px; margin-bottom: 50px;">
                            <a href="https://us8.admin.mailchimp.com/templates/*%7CUNSUB%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
                            <a href="https://us8.admin.mailchimp.com/templates/*%7CUPDATE_PROFILE%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
                            <a href="http://www.misterpompadour.com/" style="float: left; margin: 0 20px 0 0;">www.misterpompadour.com</a>    
                          </div>
                        </body>
                        </html>

                    '
        send_mandrill_email(subject, html_content)
    end

    def send_first_referral_friend
        subject = "Congratulations on Your First Friend Referral"
        html_content = "<p>You have got 1 referral friend</p>"
        html_content += "<p>http://mister-pompadour-referral.herokuapp.com/?ref=" + self.referral_code + "</p>"
        send_mandrill_email(subject, html_content)
    end

    def send_five_referral_friends
        subject = "Congratulations on 5 Friend Referrals"
        html_content = "<p>You have reacched 5 referral friends</p>"
        html_content += "<p>http://mister-pompadour-referral.herokuapp.com/?ref=" + self.referral_code + "</p>"
        send_mandrill_email(subject, html_content) 
    end

    def send_ten_referral_friends
        subject = "Congratulations on 10 Friend Referrals"
        html_content = "<p>You have reacched 10 referral friends</p>"
        html_content += "<p>http://mister-pompadour-referral.herokuapp.com/?ref=" + self.referral_code + "</p>"
        send_mandrill_email(subject, html_content)  
    end

    def send_twentyfive_referral_friends
        subject = "Congratulations on 25 Friend Referrals"
        html_content = "<p>You have reacched 25 referral friends</p>"
        html_content += "<p>http://mister-pompadour-referral.herokuapp.com/?ref=" + self.referral_code + "</p>"
        send_mandrill_email(subject, html_content) 
    end

    def send_fifty_referral_friends
        subject = "Congratulations on 50 Friend Referrals"
        html_content = "<p>You have reacched 50 referral friends</p>"
        html_content += "<p>http://mister-pompadour-referral.herokuapp.com/?ref=" + self.referral_code + "</p>"
        send_mandrill_email(subject, html_content) 
    end

    def send_remainning_emails days

        subject = "Only 2 days left for Opening."
        if self.referrals.count >= 50
            html_content = "<p>We know that you've already maxed out, but please keep referring friends</p>"
        elsif self.referrals.count >= 25
            html_content = "<p>You have #{ 50 - self.referrals.count} referral counts left until your next product level-4</p>"
        elsif self.referrals.count >= 10
            html_content = "<p>You have #{ 25 - self.referrals.count} referral counts left until your next product level-3</p>"
        elsif self.referrals.count >= 5
            html_content = "<p>You have #{ 10 - self.referrals.count} referral counts left until your next product level-2</p>"
        else        
            html_content = "<p>You have #{ 5 - self.referrals.count} referral counts left until your next product level-1</p>"
        end

        send_mandrill_email(subject, html_content) 
    end

    def send_mandrill_email(subject,html_content)

        if Rails.env.production?
            m = Mandrill::API.new
            message = {  
             :subject=> subject,  
             :from_name=> "Mister Pompadour",  
             :to=>[  
               {  
                 :email=> self.email
               }  
             ],  
             :html=> html_content,
             :from_email=>"info@misterpompadour.com"  
            }  
            async = true;
            sending = m.messages.send message, async
            puts "----------------sending mail status--------"
            puts sending
        end
        
    end

    private

    def create_referral_code
        # binding.pry
        referral_code = SecureRandom.hex(5)
        @collision = User.find_by_referral_code(referral_code)

        while !@collision.nil?
            referral_code = SecureRandom.hex(5)
            @collision = User.find_by_referral_code(referral_code)
        end

        self.referral_code = referral_code
    end

    def send_welcome_email
        #binding.pry
        # UserMailer.delay.signup_email(self)
        UserMailer.test_email(self).deliver
    end


    def add_subscribe_to_list_mailchimp
        if Rails.env.production?
            gb = Gibbon::API.new(ENV['MAILCHIMP_KEY'])
            gb.lists.subscribe({:id => ENV['MAILCHIMP_LIST_ID'], 
             :email => {:email => self.email }, :merge_vars => {:RNUM => 0, :RCODE => self.referral_code},
             :double_optin => false})
        end
        
    end

end
