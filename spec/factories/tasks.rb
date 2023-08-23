FactoryBot.define do
  factory :task do
    name { Faker::Lorem.words(number: 2).join(' ') }
    description { Faker::Lorem.sentence }
    status { %w[未着手 進行中 完了].sample }
    due_on { Faker::Date.between(from: Date.today, to: 1.year.from_now) }
    reward { Faker::Number.between(from: 10, to: 500) }
    user
  end
end
