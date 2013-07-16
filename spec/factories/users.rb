# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    ignore do
      with_identity { true }
      password { 'abcd1234' }
    end
    
    name Faker::Name::name
    sequence(:email) { |n| "user#{n}@build-notifier.com" }

    after(:create) do |user|
      FactoryGirl.create(:identity,
                         name: user.name,
                         email: user.email,
                         )
      user.add_role :admin
    end
  end
end
