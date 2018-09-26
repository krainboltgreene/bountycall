module Admin
  class DiscordContactsController < ContactsController
    private def find_resource(identifier)
      DiscordContact.find(identifier)
    end
  end
end
