## Notes

I'm making authenticated calls via the official oauth authentication system with an account that has given me third-party oauth authentication, to a publicly available graphql interface that publicly surfaces it's documentation and details. Me misinterpreting the error message and incorrectly creating HTTP requests is not bypassing security or not being unauthorized.


## Setup

heroku addons:create heroku-redis:hobby-dev --app=thebountycall --maxmemory_policy=noeviction --as=REDIS_SIDEKIQ
heroku addons:create heroku-redis:hobby-dev --app=thebountycall --maxmemory_policy=noeviction --as=REDIS_OBJECTS
heroku addons:create heroku-redis:hobby-dev --app=thebountycall --maxmemory_policy=volatile-lru --as=REDIS_CACHE
heroku addons:create heroku-redis:hobby-dev --app=thebountycall --maxmemory_policy=noeviction --as=REDIS_REDLOCK
heroku addons:create heroku-redis:hobby-dev --app=thebountycall --maxmemory_policy=noeviction --as=REDIS_ACTION_CABLE
bin/rake secret && bin/rake secret && bin/rake secret && bin/rake secret
