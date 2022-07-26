# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

return unless Rails.env == "development"

system 'clear'

p 'Deleting existing users'
User.destroy_all

p "Generating default test users"
users = User.create!([
  { email: "test@test.com", password: "passpass", confirmed: true, confirmed_at: Time.current.utc},
  { email: "test2@test.com", password: "passpass"},
  { email: "test3@test.com", password: "passpass"}])


p "Generating default test user's profiles"
users.each do |user|
  Profile.create(user: user, nickname: "User #{user.id}")
end

p "Deleting existing events"
Event.destroy_all

p "Generating a set of random events with default room & questions"
20.times do
  user = users.sample

  event = Event.create!(
    name: Faker::App.name + " by " + Faker::App.author,
    user: user,
    start_date: Faker::Date.forward(days: 30)
  )

  room = Room.create!(
    name: '__default__',
    event_id: event.id
  )

  # Adding roles
  user.add_role :admin, event
  user.add_role :admin, room

  # Adding questions
  2.times do
    Question.create!(
      room: room,
      user: users.sample,
      title: Faker::ChuckNorris.fact
    )
  end

  print '.'
end

print "\n"
p "Generating a confirmed user with empty profile and event"
User.create( email: "test1@test.com", password: "passpass", confirmed: true, confirmed_at: Time.current.utc )

p 'Seed completed'