module Admin
  class EmailContactsController < ContactsController
    private def find_resource(identifier)
      EmailContact.find(identifier)
    end
  end
end
