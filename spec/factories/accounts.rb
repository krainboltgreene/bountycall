FactoryBot.define do
  factory(:account) do
    name {Faker::Name.name()}
    email {Faker::Internet.unique.email()}
    username {Faker::Internet.unique.username()}
    password {Faker::Internet.unique.password()}
    trait(:administrator) do
      after(:create, &:upgrade_to_administrator!)
    end
  end
end
