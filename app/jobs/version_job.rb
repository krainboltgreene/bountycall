class VersionJob < ApplicationJob
  sidekiq_options(:queue => "versions", :unique_across_queues => true, :lock => :until_executed, :log_duplicate_payload => true)

  def perform(version_class, attributes)
    version_class.constantize.create!(attributes)
  end
end
