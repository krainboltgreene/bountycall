## Notes



## Setup

  0. heroku addons:create heroku-redis:{tier} --app=blank-web-rails-origin-{environment} --maxmemory_policy=noeviction --as=REDIS_SIDEKIQ
  0. heroku addons:create heroku-redis:{tier} --app=blank-web-rails-origin-{environment} --maxmemory_policy=noeviction --as=REDIS_OBJECTS
  0. heroku addons:create heroku-redis:{tier} --app=blank-web-rails-origin-{environment} --maxmemory_policy=volatile-lru --as=REDIS_CACHE
  0. heroku addons:create heroku-redis:{tier} --app=blank-web-rails-origin-{environment} --maxmemory_policy=noeviction --as=REDIS_REDLOCK
  0. bin/rake secret && bin/rake secret && bin/rake secret && bin/rake secret
