module Admin
  class ContactsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    def index
      super
      @resources = Contact.
        eager_load(:account, :versions).
        page(params[:page]).
        per(10)
    end

    # Define a custom finder by overriding the `find_resource` method:
    private def find_resource(identifier)
      Contact.eager_load(:account, :versions).find(identifier)
    end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
