FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "task#{n}" }
    description { 'test_description' }
    sequence(:expired_at) { |n| Time.now + n.days }
    status { Task::STATUS.sample } 
    priority { Task::PRIORITY.sample }

    association :user
  end
end
