module Admin
  class PhoneContactsController < ContactsController
    private def find_resource(identifier)
      PhoneContact.find(identifier)
    end
  end
end
