module Admin
  class AccountsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    def index
      super
      @resources = Account.
        eager_load(:contacts, :identities, versions: [:actor]).
        page(params[:page]).
        per(10)
    end

    # Define a custom finder by overriding the `find_resource` method:
    private def find_resource(identifier)
      Account.eager_load(:contacts, :identities, versions: [:actor]).find(identifier)
    end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
