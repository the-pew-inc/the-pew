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
  Profile.create!(user_id: user.id, nickname: Faker::Name.name )
end

p "Deleting existing events"
Event.destroy_all

p "Generating a set of random events with default room & questions"
20.times do
  user = users.sample

  event = Event.create!(
    name: Faker::App.name + " by " + Faker::App.author,
    user: user,
    status: Event.statuses.to_a.sample[1],
    always_on: [true, false].sample,
    allow_anonymous: [true, false].sample,
    start_date: Faker::Date.forward(days: 30)
  )

  room = Room.create!(
    name: '__default__',
    event: event,
    always_on: event.always_on,
    allow_anonymous: event.allow_anonymous,
    start_date: event.start_date
  )

  # Adding roles
  user.add_role :admin, event
  user.add_role :admin, room

  # Adding questions
  3.times do
    question = Question.new(
      room: room,
      user: users.sample,
      title: Faker::ChuckNorris.fact,
      status: Question.statuses.to_a.sample[1]
    )

    if question.rejected?
      question.rejection_cause = Question.rejection_causes.to_a.sample[1]
    end

    question.save!

    # Adding a nested question (aka nested question)
    # nested_question = Question.new(
    #   room: question.room,
    #   user: users.sample,
    #   title: Faker::Books::Dune.quote.truncate(250, separator: /\s/),
    #   status: Question.statuses.to_a.sample[1],
    #   parent_id: question.id
    # )

    # if nested_question.rejected?
    #   nested_question.rejection_cause = Question.rejection_causes.to_a.sample[1]
    # end

    # nested_question.save!

  end

  print '.'
end

print "\n"
p "Generating a confirmed user with empty profile and event"
u1 = User.create( email: "test1@test.com", password: "passpass", confirmed: true, confirmed_at: Time.current.utc )
Profile.create(user: u1.id, nickname: "User #{u1.id} / aka empty")

p 'Seed completed'