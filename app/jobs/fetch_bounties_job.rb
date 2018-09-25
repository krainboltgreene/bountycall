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
    request["authorization"] = "Bearer #{identity.raw.fetch("credentials").fetch("token")}"
    request.body = "{\"query\":\"{\\n  user(id: #{identity.external_id}) {\\n\\t\\tbounties(status: \\\"active\\\") {id}\\n\\t}\\n}\"}"

    response = http.request(request)
    data = JSON.parse(response.read_body)

    Rails.logger.debug(data)
  end
end
