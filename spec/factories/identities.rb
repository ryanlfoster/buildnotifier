# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :identity do
    name Faker::Name::name
    sequence(:email) { |n| "identity#{n}@build-notifier.com" }
    password { 'abcd1234' }
    password_confirmation { password }
  end
end
