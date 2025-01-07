FactoryBot.define do
  factory :auction do
    title { "Sample Auction" }
    description { "Sample description" }
    starting_price { 100.0 }
    ends_at { 1.week.from_now }
    duration { 1 }
    msp { 100.0 }  # Ensure that msp is not nil

    association :user
    association :seller, factory: :user
  end
end