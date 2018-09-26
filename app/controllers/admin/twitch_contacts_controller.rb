module Admin
  class TwitchContactsController < ContactsController
    private def find_resource(identifier)
      TwitchContact.find(identifier)
    end
  end
end
