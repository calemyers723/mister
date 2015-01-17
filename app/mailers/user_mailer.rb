class UserMailer < ActionMailer::Base
    default from: "Harry's <welcome@harrys.com>"

    def signup_email(user)
        @user = user
        @twitter_message = "#Shaving is evolving. Excited for @harrys to launch."
        @twitter_message = "#MisterPompadour #looksharpbeconfident Excited for @mistrpompadour new website launch"

        mail(:to => user.email, :subject => "Thanks for signing up!")
    end
end
