class AddAppnameToEmailSubject
  def self.delivering_email(mail)
    prefixes = []
    prefixes << Rails.application.class.parent_name
    prefixes << Rails.env.upcase unless Rails.env.production?
    prefix = "[#{prefixes.join(' ')}] "
    mail.subject.prepend(prefix)
  end
end
ActionMailer::Base.register_interceptor(AddAppnameToEmailSubject)