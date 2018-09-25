class EmailContactMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.email_contact_mailer.confirmation.subject
  #
  def confirmation
    @token = Base64.urlsafe_encode64(ENCRYPTOR.encrypt_and_sign(params.fetch(:contact_id)))
    mail(:to => params.fetch(:email))
  end
end
