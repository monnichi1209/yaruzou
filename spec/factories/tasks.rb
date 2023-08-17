FactoryBot.define do
  factory :task do
    name { "MyString" }
    description { "MyText" }
    status { "MyString" }
    due_on { "2023-08-17" }
    user_id { 1 }
    reward { 1 }
  end
end
