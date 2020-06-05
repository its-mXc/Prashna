desc 'Add auth token to users'
task add_auth_token: :environment do

  # logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  logger = Rails.logger
  logger.tagged('Rake task add auth token') {
    User.verified.without_authtoken.find_each do |user|
      logger.debug { "Generating auth token for user: #{user.id}" }
      user.generate_auth_token
      if user.save
        logger.info "Token added"
      else
        p "erorrs"
        p user.errors
        logger.info "Token could not be added"
        logger.info user.errors
      end
    end
  }
end
