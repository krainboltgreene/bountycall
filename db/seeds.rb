# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

PaperTrail.request(:whodunnit => Account::MACHINE_ID, :controller_info => {:context_id => SecureRandom.uuid(), :actor_id => nil}) do
  ActiveRecord::Base.transaction do
    if Rails.env.production? && Account.count.zero?
      krainboltgreene = Account.create!
      krainboltgreene.upgrade_to_administrator!
    end

    if Rails.env.development?
      administrator = Account.create!()
      administrator.upgrade_to_administrator!

      user = Account.create!

      PaperTrail.request(:whodunnit => administrator.id, :controller_info => {:context_id => SecureRandom.uuid(), :actor_id => administrator.id}) do
      end
    end
  end
end
