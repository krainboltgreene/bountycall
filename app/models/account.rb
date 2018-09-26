class Account < ApplicationRecord
  MACHINE_ID = "machine@system.local".freeze
  include(AuditedWithTransitions)

  has_many :identities, dependent: :destroy
  has_one :twitch_identity, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :email_contacts, dependent: :destroy
  has_many :phone_contacts, dependent: :destroy
  has_many :phone_contacts, dependent: :destroy

  validates_presence_of :role_state, :on => :update
  validates_inclusion_of :role_state, :in => ["user", "administrator"], :on => :update
  validates_presence_of :twitch_identity, :on => :update

  devise(:registerable)
  devise(:omniauthable, omniauth_providers: [:twitch])
  devise(:async)

  state_machine(:role_state, :initial => :user) do
    event(:upgrade_to_administrator) do
      transition(:user => :administrator)
    end

    event(:downgrade_to_user) do
      transition(:from => [:administrator], :to => :user)
    end

    before_transition(:do => :version_transition)

    after_transition(:on => :upgrade_to_administrator) do |record|
      record.after_transaction do
        AccountRoleMailer.with(:destination => record).upgraded_to_administrator.deliver_later
      end
    end

    after_transition(:on => :downgrade_to_user) do |record|
      record.after_transaction do
        AccountRoleMailer.with(:destination => record).downgraded_to_user.deliver_later
      end
    end
  end

  def self.find_or_create_with_omniauth(data)
    transaction do
      "#{data.fetch("provider")}Identity".
        classify.
        constantize.
        find_or_initialize_by(:external_id => data.fetch("uid")) do |identity|
          identity.assign_attributes(:account => Account.create!)
        end.
        tap {|identity| identity.assign_attributes(:raw => data) }.
        tap(&:save!).
        account
    end
  end

  def completed?
    contacts.with_confirmation_state(:confirmed).exists?
  end
end
