class TwitchContactConfirmationJob < ApplicationJob
  sidekiq_options(:queue => "contacts")

  def perform(contact_id)
    raise
  end
end
