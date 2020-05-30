desc 'Make a new admin'
task add_auth_token: :environment do

  User.find_each do |user|
    unless user.auth_token
      user.auth_token = SecureRandom.urlsafe_base64.to_s
      unless user.save
        p "erorrs"
        p user.errors
      end
    end
  end
end
