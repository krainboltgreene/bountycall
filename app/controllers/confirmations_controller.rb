class ConfirmationsController < ApplicationController
  before_action :authenticate_account!

  def show
    contact_id = ENCRYPTOR.decrypt_and_verify(Base64.urlsafe_decode64(params.require(:id)))
    contact = Contact.find(contact_id).morph

    render(:show, locals: {contact: contact})
  end
end
