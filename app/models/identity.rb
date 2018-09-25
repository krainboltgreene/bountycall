class Identity < ApplicationRecord
  include(Audited)

  belongs_to :account

  validates_presence_of :subtype
  validates_inclusion_of :subtype, :in => ["TwitchIdentity", "DiscordIdentity"]
  validates_presence_of :external_id
  validates_presence_of :raw
end
