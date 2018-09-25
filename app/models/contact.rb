class Contact < ApplicationRecord
  SLUG_TO_SUBTYPE_MAPPING = {
    "email" => "EmailContact",
    "phone" => "PhoneContact",
    "twitch" => "TwitchContact",
    "discord" => "DiscordContact"
  }
  SUBTYPE_TO_SLUG_MAPPING = SLUG_TO_SUBTYPE_MAPPING.invert
  include(AuditedWithTransitions)

  belongs_to :account

  validates_presence_of :value
  validates_presence_of :subtype
  validates_inclusion_of :subtype, :in => SLUG_TO_SUBTYPE_MAPPING.values
  validates_presence_of :confirmation_state, :on => :update
  validates_inclusion_of :confirmation_state, :in => ["unconfirmed", "confirmed"], :on => :update
  # TODO: uniqueness on value+subtype

  after_commit :trigger_confirmation, on: :create

  state_machine(:confirmation_state, :initial => :unconfirmed) do
    event(:confirm) do
      transition(:unconfirmed => :confirmed)
    end

    before_transition(:do => :version_transition)
  end

  def slug
    SUBTYPE_TO_SLUG_MAPPING.fetch(subtype)
  end

  private def trigger_confirmation
    "#{subtype}ConfirmationJob".constantize.perform_async(id)
  end
end
