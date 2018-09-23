ENCRYPTION_KEY_GENERATOR = ActiveSupport::KeyGenerator.new(Rails.application.credentials.key)
ENCRYPTION_KEY = ENCRYPTION_KEY_GENERATOR.generate_key(ENV.fetch("ENCRYPTION_SALT"), 32)
ENCRYPTOR = ActiveSupport::MessageEncryptor.new(ENCRYPTION_KEY)
