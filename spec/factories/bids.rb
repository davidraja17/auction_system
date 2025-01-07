FactoryBot.define do
  factory :bid do
    amount { 150 }
    association :buyer, factory: :user
    association :auction
  end
end