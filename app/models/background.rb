class Background < ActiveRecord::Base
  # attr_accessible :title, :body
  
  def self.send_notify_email

    #user = User.find_by_email("kyle.perez1985@gmail.com")
    user = User.find_by_email("cale.myers723@gmail.com")
    referral_code = CGI::escape(user.referral_code);

    # user.send_sign_up_email
    user.send_first_referral_friend
    user.send_five_referral_friends
    # user.send_ten_referral_friends
    # user.send_twentyfive_referral_friends
    # user.send_fifty_referral_friends

    # user.send_remainning_emails 3
    # user.send_remainning_emails 2
    # user.send_remainning_emails 1

    # users = User.all
    # for user in users
    #   begin
          
    #   rescue Exception => e
    #     puts '-----------send_notify_email_error-------------'
    #   end
    # end
  end

  def self.get_referral_count email
    if Rails.env.production?

      gb = Gibbon::API.new(ENV['MAILCHIMP_KEY'])
      list_id = ENV['MAILCHIMP_LIST_ID']
      info = gb.lists.member_info({:id => list_id, :emails => [{:email => email.downcase}]})
      puts "Mailchimp Referral Count:--------------#{info["data"][0]["merges"]["RNUM"]}"
      user = User.find_by_email(email.downcase)
      puts "Database Referral Count:***************#{user.referral_count}"
    end

    # info = gb.lists.member_info({:id => list_id, :emails => [{:email => "#{user.email}"}]})
    # info = gb.lists.member_info({:id => list_id, :emails => [{:email => "guitarboy27713@aol.com"}]})
    # User.find_by_referral_code('1c70316479')
    # user = User.find_by_email("eloisaoropeza1@gmail.com")
    # referral_code = info["data"][0]["merges"]["RCODE"]
    # gb.lists.batch_subscribe(:id => ENV['MAILCHIMP_LIST_ID'], :batch => 
    #                 [ {:email => {:email => user.email }, :merge_vars => { :RNUM => 21}}], :update_existing => true)    
  end


  def self.patch_user_database

    if Rails.env.production?
      gb = Gibbon::API.new(ENV['MAILCHIMP_KEY'])
      list_id = ENV['MAILCHIMP_LIST_ID']
      member = gb.lists.members({:id => list_id, :opts => {:start => 0, :limit => 1}})
      limit_count = member["total"]
      puts "~~~~~~~~~~~~~~total:#{limit_count}~~~~~~~~~~~~~~~~"

      for i in 0..limit_count - 1
        member = gb.lists.members({:id => list_id, :opts => {:start => i, :limit => 1}})
        email = member["data"][0]["email"].downcase
        referral_code = member["data"][0]["merges"]["RCODE"]
        referral_count = member["data"][0]["merges"]["RNUM"].to_i


        puts "**********count[#{i.to_s}]*************"


        user = User.find_by_referral_code(referral_code)
        if user.nil?
          record_email = ActiveRecord::Base.connection.quote(email)
          record_referral_code = ActiveRecord::Base.connection.quote(referral_code)
          record_referral_count = ActiveRecord::Base.connection.quote(referral_count)
          record_date = ActiveRecord::Base.connection.quote("2015-02-09 12:00:00")
          query = "INSERT INTO users (email,referral_code,referral_count, created_at, updated_at) VALUES (#{record_email}, #{record_referral_code}, #{record_referral_count}, #{record_date}, #{record_date})"
          # ActiveRecord::Base.connection.execute(query);
          puts "**************USER SAVE(#{i.to_s}):#{email}*********************"
        else
          # if user.referral_count != referral_count
          #   user.referral_count = referral_count
          #   # user.save
          #   puts "**************USER UPDATE REFERRAL CODE(#{i.to_s}):#{email}*********************"
          # elsif user.referral_code != referral_code
          #   user.referral_code = referral_code
          #   # user.save
          #   puts "**************USER UPDATE REFERRAL CODE(#{i.to_s}):#{email}*********************"
          # end

          if user.email != email || user.referral_count != referral_count
            user.email = email
            user.referral_count = referral_count
            puts "**************USER UPDATE (#{i.to_s}):#{email}*********************"
          end

          query = "delete from users where referral_code = '#{referral_code}' and id <> #{user.id}"
          ActiveRecord::Base.connection.execute(query);
        end

      end



      # index = 0
      # users = User.order('id asc')
      # missing_count = 0
      # for user in users
      #   index = index + 1
      #   info = gb.lists.member_info({:id => list_id, :emails => [{:email => user.email}]})
      #   success_count = info["success_count"].to_i
      #   puts "%%%%%%%%%%%%%#{index}"
      #   if success_count == 0
      #     puts "------------new subscribe:#{user.email}:#{user.referral_count}-------------"
      #     missing_count += 1
      #     begin
      #       gb.lists.subscribe({:id => list_id, 
      #                :email => {:email => user.email }, :merge_vars => {:RNUM => user.referral_count, :RCODE => user.referral_code},
      #                :double_optin => false})
      #               puts '------------success add subscribe-------------'  
      #     rescue Exception => e
            
      #     end
          
      #   end
        
      # end

      # puts "^^^^^^^^^^^^^^^^^^^^^^^^Total-Count:::::#{missing_count}^^^^^^^^^^^^^^^^^^^^^^^"

    end

    # User.distinct.count('email')
    # User.find(:all).group_by(&:email).count
    # User.group(:email).count
    # User.find(:all, 
    #          :select => "count(*) as email_count", 
    #          :having => "email_count > 0", 
    #          :group => 'email').size
    # User.group(:email).having("count(*) > 1").count.size

    # query = "SELECT count(distinct email) FROM users;"
    # query = "SELECT count(*) FROM users;"
    # ActiveRecord::Base.connection.execute(query);
    # gb.lists.batch_subscribe(:id => ENV['MAILCHIMP_LIST_ID'], :batch => 
    #                 [ {:email => {:email => user.email }, :merge_vars => { :RNUM => user.referral_count}}], :update_existing => true)    

    # IGoid7862@armyspy.com
    # user = User.find_by_email("kyle.perez1985@gmail.com")
    # gb.lists.subscribe({:id => list_id, 
    #                :email => {:email => user.email }, :merge_vars => {:RNUM => user.referral_count, :RCODE => user.referral_code},
    #                :double_optin => false})

    # query = "delete from users where referral_code = '1aa55299cc' and id <> 76"
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
    #user = User.find_by_email("kyle.perez1985@gmail.com")
    # user = User.where(:email => "kyle.perez1985@gmail.com")
    user = User.find_by_email("mattdavis777@gmail.com")

    for i in 1..count do
      new_user = User.new
      new_user.referrer = user
      new_user.email = "demo" + i.to_s + "@gmail.com"
      new_user.save
      user.update_list_mailchimp
    end
  end
end
