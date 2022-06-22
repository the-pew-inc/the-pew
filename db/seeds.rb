# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

Role.create([
  {name: "owner"},
  {name: "admin"},
  {name: "moderator"},
  {name: "guest"},
  {name: "billing"}
  ])

users = User.create([
  { email: "test@test.com", password: "passpass"},
  { email: "test2@test.com", password: "passpass"},
  { email: "test3@test.com", password: "passpass"}])

users.each do |user|
  Profile.create(user: user, nickname: "User #{user.id}")
end

50.times do
  Event.create(
    name: Faker::App.name,
    user: users.sample,
    start_date: Faker::Date.forward(days: 30)
  )
end