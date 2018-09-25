class FetchTwitchClientCredentialsJob < ApplicationJob
  sidekiq_options(:queue => "twitch")

  def perform()
    client_id = Rails.application.credentials.public_send(Rails.env.to_sym).fetch(:omniauth).fetch(:twitch).fetch(:shared)
    client_secret = Rails.application.credentials.public_send(Rails.env.to_sym).fetch(:omniauth).fetch(:twitch).fetch(:secret)
    grant_type = "client_credentials"
    uri = URI("https://id.twitch.tv/oauth2/token?client_id=#{client_id}&client_secret=#{client_secret}&grant_type=#{grant_type}")

    client = Net::HTTP.new(uri.host, uri.port)
    client.use_ssl = true
    client.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri)

    response = client.request(request)

    data = JSON.parse(response.read_body)
    # {
    #   "access_token": "bylid2y14eyt11fo6uj6msm59ez3v1",
    #   "expires_in": 5667539,
    #   "token_type": "bearer"
    # }

    Rails.cache.write("twitch/client_credentials", data.fetch("access_token"), expires_in: data.fetch("expires_in"))

    FetchTwitchClientCredentialsJob.perform_in(data.fetch("expires_in") - 10.seconds)
  end
end
