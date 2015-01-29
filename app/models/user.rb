
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
                                <p style="margin: 30px 0 0 0; color: #365F91; font-size: 34px;"><b>Things to remember...</b></p>
                                <ul style="font-size: 20px; list-style: inherit; color: #365F91; padding: 20px 0 0 40px; line-height: 45px;">
                                  <li>Earn FREE products...the more you share the better the prize!</li>
                                  <li>Each friend can be referred only once...reach them before others do!</li>
                                  <li>Only available from Feb. 1-8...share now before time runs out!</li>
                                </ul>
                              </div>
                              <div style="margin-top: 20px;">
                                <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_0.png">
                              </div>'
        html_content += email_footer_content(1)
        send_mandrill_email(subject, html_content)
    end

    def send_first_referral_friend
        subject = "Congratulations on Your First Friend Referral"
        html_content = referral_friends_header(0)
        html_content += email_footer_content(2)
        send_mandrill_email(subject, html_content)
    end

    def send_five_referral_friends
        subject = "Congratulations on 5 Friend Referrals"
        html_content = referral_friends_header(1)
        html_content += email_footer_content(2)
        send_mandrill_email(subject, html_content)
    end

    def send_ten_referral_friends
        subject = "Congratulations on 10 Friend Referrals"
        html_content = referral_friends_header(2)
        html_content += email_footer_content(2)
        send_mandrill_email(subject, html_content)
    end

    def send_twentyfive_referral_friends
        subject = "Congratulations on 25 Friend Referrals"
        html_content = referral_friends_header(3)
        html_content += email_footer_content(2)
        send_mandrill_email(subject, html_content)
    end

    def send_fifty_referral_friends
        subject = "Congratulations on 50 Friend Referrals"
        html_content = referral_friends_header(4)
        html_content += email_footer_content(2)
        send_mandrill_email(subject, html_content)
    end

    def send_remainning_emails days

        case days
        when 3
            subject = "Only 3 days left for the Friend Referral Campaign"
        when 2
            subject = "Only 2 days left for the Friend Referral Campaign"
        when 1
            subject = "Last Day for the Friend Referral Campaign" 
        end
        html_content = reminder_email_header(days)
        if self.referrals.count < 50
            html_content += email_footer_content(2)
        else
            html_content += email_footer_content(3)
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

    def add_subscribe_to_list_mailchimp
        if Rails.env.production?
            gb = Gibbon::API.new(ENV['MAILCHIMP_KEY'])
            gb.lists.subscribe({:id => ENV['MAILCHIMP_LIST_ID'], 
             :email => {:email => self.email }, :merge_vars => {:RNUM => 0, :RCODE => self.referral_code},
             :double_optin => false})
        end
        
    end


    
    # footer_type: 3 - reached to maximum (50)
    # footer_type: 2 - not reached to maximum
    def email_footer_content footer_type
        
        root_url = "http://mister-pompadour-referral.herokuapp.com/"
        image = CGI::escape(root_url + '/assets/refer/logo-fb69ee306dd1e2eb28dd2e5c9e0c103d.jpg');
        title = CGI::escape('Mister Pompadour');
        url = CGI::escape(root_url);
        twitter_message = CGI::escape("#MisterPompadour #looksharpbeconfident Excited for @mistrpompadour new website launch.")
        referral_code = CGI::escape(self.referral_code);

        footer_content = '<div style="margin: 15px 0 0 0;">
                            <p style="font-weight: bold; color: #4F81BC; font-size: 32px;">Your Unique Referral Code</p>
                          </div>
                          <div style="background-color: #F1F0EE; width: 480px; margin: 7px auto; padding: 20px 25px;">
                            <div style="border: 1px solid #D1D0C7; background: #FFF; padding: 10px 0; font-size: 11px;">'
        footer_content += root_url
        footer_content += '?ref='
        footer_content += self.referral_code
        footer_content += '</div>
                          <div style="width: 120px; height:37px; margin: 25px auto 0; text-aling: center;">
                            <a href="http://www.facebook.com/sharer.php?u='
        footer_content += url
        footer_content += '?ref='
        footer_content += referral_code
        footer_content += '&p[title]='
        footer_content += title
        footer_content += '&p[images][0]='
        footer_content += image
        footer_content += '" target="_blank" style="background: url(http://mister-pompadour-referral.herokuapp.com/assets/refer/fb.png); background-size: 27px 27px; width:27px; height: 27px; display: inline-block;"></a>
                          <div style="height: 28px; width: 1px; background: #bab9ba; margin: 0 20px; display: inline-block;"></div>
                          <a href="http://twitter.com/share?url='
        footer_content += url
        footer_content += '?ref='
        footer_content += referral_code
        footer_content += '&text='
        footer_content += twitter_message

        footer_content += '" target="_blank" style="background: url(http://mister-pompadour-referral.herokuapp.com/assets/refer/twit.png); background-size: 27px 27px; width:27px; height: 27px; display: inline-block;"></a>
                            </div>  
                          </div>
                          '
        # footer_content += '<div style="background-color: #E26C09;margin: 20px auto; width: 570px; border-radius: 10px;">
        #                     <a href="<%= root_url %>?ref=df2c2abfff" style="text-decoration: blink;"><p style="padding: 10px 10px; font-size: 28px; color: white;">Click Here for <i>Friend Referral Dashboard</i></p></a>
        #                   </div>'
        
        footer_content += '<div style="background-color: #E26C09;margin: 20px auto; width: 570px; border-radius: 10px;">
                            <a href="'
        footer_content += root_url
        footer_content += '?ref='
        footer_content += referral_code
        footer_content += '" style="text-decoration: blink;"><p style="padding: 10px 10px; font-size: 28px; color: white;">Click Here for <i>Friend Referral Dashboard</i></p></a>
                          </div>'

        if footer_type == 3
                
            footer_content += '<div style="text-align: left;">
                            <p style="margin: 30px 0 0 10px; font-size: 36px; font-weight: bold; color: #365F91;">Remember...</p>
                            <ul style="font-size: 20px; list-style: inherit; color: #365F91; padding: 10px 0 0 65px; line-height: 45px;">
                                <li>Even though you\'ve earned the max reward we still appreciate you spreading the word!</li></ul>
                          '
        elsif footer_type == 2
            
            footer_content += '<div style="text-align: left;">
                            <p style="margin: 30px 0 0 10px; font-size: 36px; font-weight: bold; color: #365F91;">Remember...</p>
                            <ul style="font-size: 20px; list-style: inherit; color: #365F91; padding: 10px 0 0 65px; line-height: 45px;">
                            <li>Earn FREE products...the more you share the better the prize!</li>
                              <li>Each friend can be referred only once...reach them before others do!</li>
                              <li>Only available from Feb. 1-8...share now before the campaign is gone forever!</li></ul>
                          '
        end

        footer_content += '</div>
                          <div style="background-color: #233E5F;margin: 30px auto; ">
                            <p style="padding: 17px 20px; font-size: 34px; color: white;">LOOK SHARP. BE CONFIDENT.</p>
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
                        </html>'
    end

    def referral_friends_header header_type

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
                                  Congratulations!'
        if header_type != 0
            html_content += ' You\'ve earned the'
        end
        referral_title = ''
        referral_content =''
        image_path = ''
        case header_type
        when 0
            referral_title = '<p style="text-align:left; margin: 5px 0 0; "><span style="color: #C00000; font-weight: bold;">1</span> friend has joined the <i>Friend Referral Campaign</i></p>'
            referral_content = '<p style="margin: 30px 0 0 0; color: #355F91; font-size: 34px; font-weight: bold;">Only <span style="color: #C00000;">4</span> more friend referrals to earn FREE product!</p>'
        when 1
            referral_title = '<p style="text-align:left; margin: 5px 0 0; font-weight: bold;">Peppermint Shower Experience Travel Kit</i></p>'
            referral_content = '<p style="margin: 30px 0 0 0; color: #355F91; font-size: 34px; font-weight: bold;">Thanks to you <span style="color: #C00000;">5</span> friends have officially joined!</p>'
        when 2
            referral_title = '<p style="text-align:left; margin: 5px 0 0; font-weight: bold;">Styling Product of Your Choice</i></p>'              
            referral_content = '<p style="margin: 30px 0 0 0; color: #355F91; font-size: 34px; font-weight: bold;">Thanks to you <span style="color: #C00000;">10</span> friends have officially joined!</p>'
        when 3
            referral_title = '<p style="text-align:left; margin: 5px 0 0; font-weight: bold;">Complete Kit of Your Choice</i></p>'
            referral_content = '<p style="margin: 30px 0 0 0; color: #355F91; font-size: 34px; font-weight: bold;">Thanks to you <span style="color: #C00000;">25</span> friends have officially joined!</p>'
        when 4
            referral_title = '<p style="text-align:left; margin: 5px 0 0; font-weight: bold;">$100 Mister Pompadour Gift Certificate</i></p>  '
            referral_content = '<p style="margin: 30px 0 0 0; color: #355F91; font-size: 34px; font-weight: bold;">Extraordinary! You\'ve officially referred <span style="color: #C00000;">50</span> friends!</p>'
        end
        image_path = 'email_' + header_type.to_s + '.png'
        html_content += referral_title
        html_content += '<hr style="font-size: 15px; width: 790px; color: #4F81BC;" />
                              </div>

                              <div style="clear: both;"></div>
                              <div style="text-align: left;">'
        html_content += referral_content
        html_content += '</div>
                              <div style="margin-top: 20px;">
                                <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/'
        html_content += image_path
        html_content += '">
                              </div>'
       
    end

    def reminder_email_header days
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
                                  '
        str_days = ''
        case days
        when 3
            str_days = 'Only 3 days left'
        when 2
            str_days = 'Only 2 days left'  
        when 1
            str_days = 'Last day'  
        end
        html_content += str_days
        html_content += ' for the <i>Friend Referral Campaign...</i>
                            </p>
                            <p style="text-align:left; margin: 5px 0 0; font-weight: bold;">'
        html_title = ''
        html_sub_title = ''
        image_path = 'email_0.png'
        remain_referrals_count = 0
        if self.referrals.count < 5
            remain_referrals_count = 5 - self.referrals.count
            image_path = 'email_0.png'
        elsif self.referrals.count < 10
            remain_referrals_count = 10 - self.referrals.count
            image_path = 'email_1.png'
        elsif self.referrals.count < 25
            remain_referrals_count = 25 - self.referrals.count
            image_path = 'email_2.png'
        elsif self.referrals.count < 50
            remain_referrals_count = 50 - self.referrals.count            
            image_path = 'email_3.png'
        else
            image_path = 'email_4.png'
        end
        if self.referrals.count < 50
            html_title = 'Don\'t miss out on FREE products!'
            html_sub_title = 'Only <span style="color: #C00000;">'
            html_sub_title += remain_referrals_count.to_s
            html_sub_title += '</span> more friend referrals until your next prize!'
        else
            html_title = 'Max prize achieved but we still need your help!'
            html_sub_title = 'You\'ve already referred <span style="color: #C00000;">50</span> friend referrals, but don\'t let that stop you from referring more!'
        end
        html_content += html_title
        html_content += '</p>  
                            <hr style="font-size: 15px; width: 790px; color: #4F81BC;" />
                          </div>

                          <div style="clear: both;"></div>
                          <div style="text-align: left;">
                            <p style="margin: 30px 0 0 0; color: #355F91; font-size: 34px; font-weight: bold;">'

        html_content += html_sub_title
        html_content += '</p>
                          </div>

                          <div style="margin-top: 20px; color: #355F91;">
                            <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/'

        html_content += image_path
        html_content += '" style="border: 5px solid #233e5f;">
                            </div>'
    end



end
