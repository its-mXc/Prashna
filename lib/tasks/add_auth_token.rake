desc 'Add auth token to users'
task add_auth_token: :environment do

  #FIXME_AB: User.verified.without_authtoken
  #FIXME_AB: use tagged logging
  logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  User.verified.without_authtoken.find_each do |user|
    unless user.auth_token
      logger.tagged('Rake task add auth token') { 
        user.generate_auth_token
        if user.save
          logger.info "Token added"
          logger.info user
        else
          p "erorrs"
          p user.errors
          logger.info "Token could not be added"
          logger.info user.errors
        end
      }         
      #FIXME_AB: use user.generate_auth_token
    end
  end
end
