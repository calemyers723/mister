class Background < ActiveRecord::Base
  # attr_accessible :title, :body
  
    def self.send_notify_email
        root_url = "http://mister-pompadour-referral.herokuapp.com/"
        image = CGI::escape(root_url + '/assets/refer/logo-fb69ee306dd1e2eb28dd2e5c9e0c103d.jpg');
        title = CGI::escape('Mister Pompadour');
        url = CGI::escape(root_url);
        twitter_message = CGI::escape("#MisterPompadour #looksharpbeconfident Excited for @mistrpompadour new website launch.")


        user = User.find_by_email("kyle.perez1985@gmail.com")
        #user = User.find_by_email("mattdavis777@gmail.com")
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

    end
end
