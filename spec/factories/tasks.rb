FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "task#{n}" }
    description { 'test_description' }

    association :user
  end
end
