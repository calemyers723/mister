
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
        html_content = "<html><p>Thank you for signing up, please refer friends using your unique code</p>"
        html_content += "<p>http://mister-pompadour-referral.herokuapp.com/?ref=" + self.referral_code + "</p>"
        html_content += "</html>"
        subject = "Welcome Email"
        # html_content = '<!DOCTYPE html>
        #             <html lang="en">
        #             <head>
        #               <meta charset="utf-8">
        #               <title>Welcome</title>
                        
        #                 <style type="text/css">
        #                   body {
        #                     margin: 0 auto;
        #                     width: 950px;
        #                     text-align: center;
        #                     font-family: Arial;
        #                     font-size: 25px;
        #                   }

        #                   .email-logo {
        #                     text-align: center;
        #                     margin: 20px 0 0 0;
        #                   }

        #                   .email-title h1 {
        #                     font-size: 50px;
        #                     margin: 20px 0 0 0;
        #                   }

        #                   .email-content-1 p {
        #                     /*font-size: 25px;*/
        #                     margin: 30px 0 0 0;
        #                   }
        #                   .email-content-2 p {
        #                     /*font-size: 25px;*/
        #                     font-weight: bold;
        #                   }
        #                   .email-content-3 p {
        #                     /*font-size: 25px;*/
        #                     font-weight: bold;
        #                     margin: 20px 0 0 0;
        #                   }
        #                   .email-content-4 p {
        #                     /*font-size: 25px;*/
        #                   }
        #                   .email-footer p {
        #                     font-size: 45px;
        #                     margin: 20px 0 20px 0;
        #                   }

        #                 </style>
        #             </head>

        #             <body >
        #               <div class="email-logo">
        #                 <img src="/assets/refer/logo.jpg">
        #               </div>
        #               <div class="email-title">
        #                 <h1>
        #                   Let the Sharing Begin
        #                 </h1>  
        #               </div>

        #               <div class="email-content-1">
        #                 <p>You have been granted exclusive access to the Mister Pompadour<br>
        #                 Friend Referral System.The referral system is quite simple: the</p>
        #               </div>
        #               <div class="email-content-2">
        #                 <p>more friends you refer, the more FREE product you earn.</p>
        #               </div>
        #               <div style="margin-top: 20px;">
        #                 <img src="/assets/refer/email_1.jpg">
        #               </div>
        #               <div class="email-content-3">
        #                 <p>Friend Referral System will only be available form Feb.1 -8</p>
        #               </div>
        #               <div class="email-content-4">
        #                 <p>Share your unique referral code with all of your friends and<br>
        #                 family (and any one else you may know that cares about having<br>
        #                 good looking hair).</p>
        #               </div>
        #               <div style="margin-top: 20px;">
        #                 <img src="/assets/refer/email_2.jpg">
        #               </div>
        #               <div class="email-footer">
        #                 <p>Mister Pompadour. Look Sharp. Be Confident</p>
        #               </div>
                      
        #             </body>
        #             </html>
        #             '

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
