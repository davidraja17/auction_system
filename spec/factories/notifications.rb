FactoryBot.define do
  factory :notification do
    message { 'You have been outbid!' }
    association :user
  end
end
