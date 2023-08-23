# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

unless User.exists?(email: 'admin@example.com')
  User.create!(email: 'admin@example.com', password: 'password', name: 'Admin', admin: true)
end

# 親のユーザーの初期データ
parent_users = []
5.times do |i|
  parent_users << User.create(
    email: "user#{i + 1}@example.com",
    password: 'password',
    name: "User #{i + 1}",
  )
end

# "こども"のroleを持つユーザーの初期データ
parent_users.each do |parent|
  5.times do |i|
    child = User.create(
      email: SecureRandom.uuid + "@example.com",
      password: 'password',
      name: "Child #{i + 1} of #{parent.name}",
      role: 0
    )
    # FamilyLinkを作成して親子関係を表現
    FamilyLink.create(parent_id: parent.id, child_id: child.id)
  end
end

# タスクの初期データ
users = User.where.not(role: 0) # "こども"のroleを持たないユーザーを取得
due_dates = [Date.today, Date.today + 1, Date.today + 7] # 今日、明日、来週の日付

users.each do |user|
  5.times do |i|
    Task.create(
      name: "Task #{i + 1} for #{user.name}",
      description: "This is a description for Task #{i + 1} owned by #{user.name}",
      due_on: due_dates.sample # 3つの日付からランダムに選ぶ
    )
  end
end
