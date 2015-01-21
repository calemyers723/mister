
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

    private

    def send_mandrill_email(subject,html_content)
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
        sending = m.messages.send message  
        puts "----------------sending mail status--------"
        puts sending
    end


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
