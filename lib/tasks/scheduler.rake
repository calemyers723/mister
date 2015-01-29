desc "This task is called by the Heroku scheduler add-on"

task :send_reminders => :environment do
  puts 'starting reminder sending'
  Background.send_notify_email
end


task :send_reminder_emails => :environment do
  puts 'starting reminder sending'
  Background.reminder_emails
end