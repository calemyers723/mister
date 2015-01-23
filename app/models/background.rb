class Background < ActiveRecord::Base
  # attr_accessible :title, :body

  def self.send_notify_email

        # user = User.find_by_email("cale.myers723@gmail.com")
        # subject = "Welcome Email"
        # html_content = '<!DOCTYPE html>
        #                 <html lang="en">
        #                 <head>
        #                   <meta charset="utf-8">
        #                   <title>Welcome</title>
                            
        #                     <style type="text/css">
        #                       body {
        #                         margin: 0 auto;
        #                         width: 950px;
        #                         text-align: center;
        #                         font-family: Arial;
        #                         font-size: 25px;
        #                       }

        #                       .email-logo {
        #                         text-align: center;
        #                         margin: 20px 0 0 0;
        #                       }

        #                       .email-title h1 {
        #                         font-size: 50px;
        #                         margin: 20px 0 0 0;
        #                       }

        #                       .email-content-1 p {
        #                         /*font-size: 25px;*/
        #                         margin: 30px 0 0 0;
        #                       }
        #                       .email-content-2 p {
        #                         /*font-size: 25px;*/
        #                         font-weight: bold;
        #                       }
        #                       .email-content-3 p {
        #                         /*font-size: 25px;*/
        #                         font-weight: bold;
        #                         margin: 20px 0 0 0;
        #                       }
        #                       .email-content-4 p {
        #                         /*font-size: 25px;*/
        #                       }
        #                       .email-footer p {
        #                         font-size: 45px;
        #                         margin: 20px 0 20px 0;
        #                       }

        #                     </style>
        #                 </head>

        #                 <body >
        #                   <div class="email-logo">
        #                     <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_logo.jpg">
        #                   </div>
        #                   <div class="email-title">
        #                     <h1>
        #                       Let the Sharing Begin
        #                     </h1>  
        #                   </div>

        #                   <div class="email-content-1">
        #                     <p>You have been granted exclusive access to the Mister Pompadour<br>
        #                     Friend Referral System.The referral system is quite simple: the</p>
        #                   </div>
        #                   <div class="email-content-2">
        #                     <p>more friends you refer, the more FREE product you earn.</p>
        #                   </div>
        #                   <div style="margin-top: 20px;">
        #                     <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_1.jpg">
        #                   </div>
        #                   <div class="email-content-3">
        #                     <p>Friend Referral System will only be available form Feb.1 -8</p>
        #                   </div>
        #                   <div class="email-content-4">
        #                     <p>Share your unique referral code with all of your friends and<br>
        #                     family (and any one else you may know that cares about having<br>
        #                     good looking hair).</p>
        #                   </div>
        #                   <div style="margin-top: 20px;">
        #                     <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_2.jpg">
        #                   </div>
        #                   <div class="email-footer">
        #                     <p>Mister Pompadour. Look Sharp. Be Confident</p>
        #                   </div>
                          
        #                 </body>
        #                 </html>
        #               '

        # user.send_mandrill_email(subject, html_content)

        end_time = AdminUser.first.created_at + 7.days
        end_time = end_time.to_time.to_i
        now_time = Time.now.to_time.to_i
        remain_time = end_time - now_time

        timestamp_day = 60 * 60 * 24
        remain_day = remain_time / timestamp_day

        puts remain_day

        if remain_day == 3 && $flag_four != true
          $flag_four = true
          puts 'start five days'
        end
        if remain_day == 2 && $flag_five != true
          $flag_five = true
          puts 'start five days'
        end
        if remain_day == 1 && $flag_sex != true
          $flag_sex = true
          puts 'start six days'
        end

        users = User.all
        for user in users do
          puts user.email
        end
   
    end
end
