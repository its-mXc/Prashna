namespace :admin do
  desc 'Make a new admin'
  task new: :environment do

    def get_attr_value(attr)
      print("#{attr}: ")
      STDIN.gets.chomp
    end


    user = User.new(name: get_attr_value(:name),
                    email: get_attr_value(:email),
                    password: STDIN.getpass("Password:"),
                    password_confirmation: STDIN.getpass("Confirm Password:"),
                    user_type: "admin",
                    verified_at: Time.current )
    if user.save
      user.verify!
      puts "Admin created with #{user.email}"
    else
      p user.errors
    end
  end
end
