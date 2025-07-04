FactoryBot.define do
  factory :person do
    name { Faker::Name.name }
    organization { Faker::Commerce.department }
    email { Faker::Internet.email }
  end
end
