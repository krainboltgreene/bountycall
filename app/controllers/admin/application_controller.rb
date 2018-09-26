# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action(:authenticate_account!)
    before_action(:authorize_administrator!)
    before_action(:assign_paper_trail_context)
    before_bugsnag_notify(:assign_account_context)
    before_bugsnag_notify(:assign_request_tab)
    rescue_from(StandardError, :with => :generic_error_handling)

    etag {current_account&.id}

    def authorize_administrator!
      raise(Pundit::NotAuthorizedError, :message => "you're not allowed to use this resource") unless current_account.administrator?
    end

    private def assign_paper_trail_context
      if account_signed_in?
        PaperTrail.request.whodunnit = current_account.id
      else
        PaperTrail.request.whodunnit = Account::MACHINE_ID
      end

      PaperTrail.request.controller_info = {
        :actor_id => if account_signed_in? then current_account.id end,
        :context_id => request.request_id
      }
    end

    private def assign_account_context(report)
      return unless account_signed_in?

      report.user = {
        :id => current_account.id
      }
    end

    private def assign_request_tab(report)
      report.add_tab(
        :request,
        :request_id => request.request_id,
        :session_id => if account_signed_in? then session.id end
      )
    end

    private def generic_error_handling(exception)
      RequestErrorHandlingOperation.(:controller => self, :exception => exception)
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
