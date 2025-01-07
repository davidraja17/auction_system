FactoryBot.define do
  factory :auto_bid do
    max_bid { 500 }
    association :user
    association :auction
  end
end
