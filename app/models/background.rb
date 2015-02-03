class Background < ActiveRecord::Base
  # attr_accessible :title, :body
  
  def self.send_notify_email

    user = User.find_by_email("kyle.perez1985@gmail.com")
    # user = User.find_by_email("mattdavis777@gmail.com")
    referral_code = CGI::escape(user.referral_code);

    user.send_sign_up_email
    user.send_first_referral_friend
    user.send_five_referral_friends
    user.send_ten_referral_friends
    user.send_twentyfive_referral_friends
    user.send_fifty_referral_friends

    user.send_remainning_emails 3
    user.send_remainning_emails 2
    user.send_remainning_emails 1

    users = User.all
    for user in users
      begin
          
      rescue Exception => e
        puts '-----------send_notify_email_error-------------'
      end
    end
  end

  def self.reminder_emails
    end_time = AdminUser.first.created_at + 7.days + 1.hour
    end_time = end_time.to_time.to_i
    now_time = Time.now.to_time.to_i
    remain_time = end_time - now_time

    timestamp_day = 60 * 60 * 24
    remain_day = remain_time / timestamp_day
    puts remain_day
    if remain_day <= 3 && remain_day >= 1
      users = User.all
      for user in users do
        puts user.email
        begin
          user.send_remainning_emails remain_day
        rescue Exception => e
          puts "Reminder email sending error"
        end
      end
    end
  end

  def self.generate_dummy_emails count
    user = User.find_by_email("kyle.perez1985@gmail.com")
    # user = User.find_by_email("mattdavis777@gmail.com")

    for i in 1..count do
      new_user = User.new
      new_user.referrer = user
      new_user.email = "demo" + i.to_s + "@gmail.com"
      new_user.save
      user.update_list_mailchimp
    end
  end
end
