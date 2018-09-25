FactoryBot.define do
  factory(:account) do
    trait(:administrator) do
      after(:create, &:upgrade_to_administrator!)
    end
  end
end
