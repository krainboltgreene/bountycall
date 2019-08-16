class FetchBountiesJob < ApplicationJob
  sidekiq_options(:queue => "bounties")

  def perform(identity_id)
    identity = Identity.find(identity_id).morph
    client_id = Rails.application.credentials.public_send(Rails.env.to_sym).fetch(:omniauth).fetch(:twitch).fetch(:shared)
    uri = URI("https://gql.twitch.tv/gql")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri)
    request["Client-Id"] = client_id
    request["Accept"] = "application/json; charset=utf-8"
    request["Authorization"] = "OAuth #{identity.raw.fetch("credentials").fetch("token")}"
    request.body = "{\"query\":\"{\\n  user(id: #{identity.external_id}) {\\n\\t\\tbounties(status: \\\"COMPLETED\\\") {id}\\n\\t}\\n}\"}"

    response = http.request(request)

    Rails.logger.info("BOUNTY: #{response.body}")
  end
end
