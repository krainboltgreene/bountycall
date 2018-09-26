module Admin
  class DiscordIdentitiesController < IdentitiesController
    private def find_resource(identifier)
      DiscordIdentity.find(identifier).morph
    end
  end
end
