desc "This task is called by the Heroku scheduler add-on"

task :send_reminders => :environment do
  puts 'starting reminder sending'
  User.send_notify_email
end