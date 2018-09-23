class Account < ApplicationRecord
  MACHINE_ID = "machine@system.local".freeze
  USERNAME_PATTERN = /\A[a-z0-9_\-\.]+\z/i
  include(FriendlyId)
  include(AuditedWithTransitions)

  friendly_id(:email, :use => [:slugged, :history], :slug_column => :username)

  devise(:database_authenticatable)
  devise(:confirmable)
  devise(:lockable)
  devise(:recoverable)
  devise(:registerable)
  devise(:rememberable)
  devise(:validatable)
  devise(:async)

  before_validation(:generate_password, :unless => :encrypted_password?)
  before_validation(:generate_authentication_secret, :unless => :authentication_secret?)

  state_machine(:onboarding_state, :initial => :converted) do
    event(:complete) do
      transition(:from => :converted, :to => :completed)
    end

    before_transition(:do => :version_transition)
  end

  state_machine(:role_state, :initial => :user) do
    event(:upgrade_to_administrator) do
      transition(:user => :administrator)
    end

    event(:downgrade_to_user) do
      transition(:from => [:administrator], :to => :user)
    end

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
    after_transition(:on => :despark) do |record|
      record.after_transaction do
        AccountRoleMailer.with(:destination => record).downgraded_to_user.deliver_later
      end
    end
  end

  validates_presence_of(:username, :if => :email_required?)
  validates_format_of(:username, :with => USERNAME_PATTERN, :if => :email_required?)

  private def generate_password
    assign_attributes(:password => SecureRandom.hex(60))
  end

  private def generate_authentication_secret
    assign_attributes(:authentication_secret => Devise.friendly_token)
  end

  private def email_required?
    onboarding_state?(:converted) || onboarding_state?(:completed)
  end

  private def completable?
    email.present? && name.present?
  end

  private def account_confirmed
    complete! if onboarding_state?(:converted) && can_complete?
  end
end
