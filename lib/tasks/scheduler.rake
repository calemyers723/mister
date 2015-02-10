desc "This task is called by the Heroku scheduler add-on"

task :send_reminders => :environment do
  puts 'starting reminder sending'
  Background.send_notify_email
end


task :send_reminder_emails => :environment do
  Background.reminder_emails
end

task :patch_user_database => :environment do
  Background.patch_user_database
end