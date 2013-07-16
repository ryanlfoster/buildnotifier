# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authorization do
    provider 'identity'
    sequence(:uid) { |n| "authorization#{n}@build-notifier.com" }
  end
end
