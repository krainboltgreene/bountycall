config = Timber::Config.instance

config.integrations.action_view.silence = Rails.env.production?

# Add additional configuration here.
# For common configuration options see:
# https://timber.io/docs/languages/ruby/configuration
#
# For a full list of configuration options see:
# http://www.rubydoc.info/github/timberio/timber-ruby/Timber/Config

