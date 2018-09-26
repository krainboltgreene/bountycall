module Admin
  class TwitchIdentitiesController < IdentitiesController
    private def find_resource(identifier)
      TwitchIdentity.find(identifier).morph
    end
  end
end
