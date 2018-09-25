class EmailContactConfirmationJob < ApplicationJob
  sidekiq_options(:queue => "contacts")

  def perform(contact_id)
    contact = Contact.find(contact_id).morph

    EmailContactMailer.with(:email => contact.value, :contact_id => contact_id).confirmation.deliver_now
  end
end
