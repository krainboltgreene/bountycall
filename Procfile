web: bin/web
release: bin/release
worker: bundle exec sidekiq --concurrency=5 --queue=bounties --queue=twitch --queue=contacts --queue=mailers --queue=versions
