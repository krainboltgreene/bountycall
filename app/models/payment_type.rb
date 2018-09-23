class PaymentType < ApplicationRecord
  include(Moderated)


  validates_presence_of(:name)
  validates_uniqueness_of(:name)
end
