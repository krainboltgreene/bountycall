class SidekiqServerPaperTrailMiddleware
  def call(_, job, _)
    if job.key?("cron")
      whodunnit = Account::MACHINE_ID
      metadata = {
        "context_id" => SecureRandom.uuid(),
        "actor_id" => SecureRandom.uuid()
      }
    else
      paper_trail = job.fetch("paper_trail")

      raise(ApplicationError, "No PaperTrail available") if paper_trail.blank?

      whodunnit = paper_trail.fetch("whodunnit")

      raise(ApplicationError, "No PaperTrail whodunnit available") if whodunnit.blank?

      metadata = paper_trail.fetch("metadata")

      raise(ApplicationError, "No PaperTrail metadata available") if metadata.blank?
    end

    PaperTrail.request(:whodunnit => whodunnit, :controller_info => {:context_id => metadata.fetch("context_id"), :actor_id => metadata.fetch("actor_id")}) do
      yield
    end
  end
end
