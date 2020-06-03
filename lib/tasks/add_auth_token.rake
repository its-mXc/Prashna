desc 'Add auth token to users'
task add_auth_token: :environment do

  #FIXME_AB: User.verified.without_authtoken
  #FIXME_AB: use tagged logging
  User.find_each do |user|
    unless user.auth_token
      #FIXME_AB: use user.generate_auth_token
      user.auth_token = SecureRandom.urlsafe_base64.to_s
      unless user.save
        p "erorrs"
        p user.errors
      end
    end
  end
end
