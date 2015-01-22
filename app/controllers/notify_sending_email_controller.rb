class NotifySendingEmailController < ApplicationController

  def send_email

    users = User.all
    for user in users do
      if Rails.env.production?
        user.send_remainning_emails
      else
        # binding.pry

        puts '!@#$@!#$@#!$@!#$@#!$@#!$@#!$@#!$@#!$@#!$@!#$'
        puts '!@#$@!#$@#!$@!#$@#!$@#!$@#!$@#!$@#!$@#!$@!#$'
        puts '!@#$@!#$@#!$@!#$@#!$@#!$@#!$@#!$@#!$@#!$@!#$'
        puts '!@#$@!#$@#!$@!#$@#!$@#!$@#!$@#!$@#!$@#!$@!#$'
        puts '!@#$@!#$@#!$@!#$@#!$@#!$@#!$@#!$@#!$@#!$@!#$'
        puts '!@#$@!#$@#!$@!#$@#!$@#!$@#!$@#!$@#!$@#!$@!#$'
        puts user.email
      end
    end

    respond_to do |format|
      format.html # new.html.erb
    end

  end

end
