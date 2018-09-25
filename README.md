## Notes



## Setup

heroku addons:create heroku-redis:hobby-dev --app=thebountycall --maxmemory_policy=noeviction --as=REDIS_SIDEKIQ
heroku addons:create heroku-redis:hobby-dev --app=thebountycall --maxmemory_policy=noeviction --as=REDIS_OBJECTS
heroku addons:create heroku-redis:hobby-dev --app=thebountycall --maxmemory_policy=volatile-lru --as=REDIS_CACHE
heroku addons:create heroku-redis:hobby-dev --app=thebountycall --maxmemory_policy=noeviction --as=REDIS_REDLOCK
heroku addons:create heroku-redis:hobby-dev --app=thebountycall --maxmemory_policy=noeviction --as=REDIS_ACTION_CABLE
bin/rake secret && bin/rake secret && bin/rake secret && bin/rake secret
