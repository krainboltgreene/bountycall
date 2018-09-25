class Accounts::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should also create an action method in this controller like this:
  # def twitter
  # end
  def twitch
    account = Account.find_or_create_with_omniauth(request.env.fetch("omniauth.auth"))

    if account.persisted?
      sign_in_and_redirect account, event: :authentication # this will throw if @account is not activated
      set_flash_message(:notice, :success, kind: "Twitch") if is_navigational_format?
    else
      session["devise.twitch_data"] = request.env["omniauth.auth"]
      redirect_to new_account_registration_url
    end
  end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  def after_omniauth_failure_path_for(scope)
    new_registration_url(scope)
  end
end
