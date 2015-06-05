namespace :db do
  desc "Create Admin"
  task create_admin: :environment do

    usr = User.create({fname:"Jane", lname: "Doe", email: "superadmin@test.com",
                       password:"123456", password_confirmation:"123456"})
    puts usr.errors.full_messages if usr.errors.any?
  end
end