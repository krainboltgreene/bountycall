module RailsConsoleAccountAccess
  def initialize(*arguments)
    return super(*arguments) if Rails.env.development? || Rails.env.test?

    Rails.logger.info("Welcome! What is your id?")

    id = gets.chomp

    raise(NoConsoleAuthenticationProvidedError) if id.blank?

    actor = Account.find_by!(:id => id)

    PaperTrail.request.whodunnit = actor.id

    PaperTrail.request.controller_info = {
      :context_id => SecureRandom.uuid(),
      :actor_id => actor.id
    }

    super(*arguments)
  end
end

Rails::Console.prepend(RailsConsoleAccountAccess) if Rails.const_defined?("Console")
