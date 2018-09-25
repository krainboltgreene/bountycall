class FetchAllBountiesJob < ApplicationJob
  sidekiq_options(:queue => "bounties")

  def perform()
    Account.joins(:twitch_identity).eager_load(:twitch_identity).find_each do |account|
      FetchBountiesJob.perform_async(account.twitch_identity.id)
    end
  end
end
