FactoryBot.define do
  factory :certificates do
    full_name { Faker::Internet.domain_name }
    association :domain
  end
end
