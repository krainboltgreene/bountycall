module Admin
  class VersionsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:

    def index
      super
      @resources = Version.
        eager_load(:actor).
        page(params[:page]).
        per(10)
    end

    # Define a custom finder by overriding the `find_resource` method:
    def find_resource(identity)
      Version.eager_load(:actor).find(identity)
    end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information

    def valid_action?(name, resource = resource_class)
      [:show, :index].include?(name) && super
    end
  end
end
