FactoryBot.define do
  factory :domain do
    full_name { Faker::Internet.domain_name }
    association :person
  end
end
