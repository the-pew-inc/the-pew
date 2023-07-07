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
  { email: "test3@test.com", password: "passpass"},
  { email: "test4@test.com", invited: true, invited_at: Time.current.utc},
  { email: "test5@test.com", invited: true, invited_at: Time.current.utc}])


p "Generating default user's profiles"
users.each do |user|
  Profile.create!(user_id: user.id, nickname: Faker::Name.name )
end

p "Updating user test default organization"
users[0].organization.update!(name: "ACME", website: "https://acme.com", domain: "acme.com")

p "Placing users test5 and test6 into the same organization as user test"
Member.create!(user_id: users[3].id, organization_id: users[0].organization.id, owner: false)
Member.create!(user_id: users[4].id, organization_id: users[0].organization.id, owner: false)

p "Making test4 an organization admin"
users[3].add_role :admin, users[0].organization

p "Deleting existing events"
Event.destroy_all

p "Generating a set of random events with default room & questions"
20.times do
  user = users.sample

  event = Event.create!(
    name: Faker::App.name + " by " + Faker::App.author,
    user: user,
    status: Event.statuses.to_a.sample[1],
    organization_id: Member.where(user_id: user.id).first.organization_id,
    always_on: [true, false].sample,
    allow_anonymous: [true, false].sample,
    start_date: Faker::Date.forward(days: 30)
  )

  room = Room.create!(
    name: '__default__',
    event: event,
    organization_id: Member.where(user_id: user.id).first.organization_id,
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
      organization_id: room.organization_id,
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
p "Making test5 an event admin of test"
users[4].add_role :admin, users[0].events.first

print "\n"
p "Generating a confirmed user with empty profile and event"
u1 = User.create( email: "test1@test.com", password: "passpass", confirmed: true, confirmed_at: Time.current.utc )
Profile.create!(user_id: u1.id, nickname: "User 1 / aka empty")

print "\n"
p 'Deleting FoodForThought'
FoodForThought.destroy_all
12.times do
  FoodForThought.create!(title: Faker::Book.unique.title, summary: Faker::Books::Dune.quote)
end
4.times do
  FoodForThought.create!(title: Faker::Book.unique.title, summary: Faker::Books::Dune.quote, sponsored: true, sponsored_by: Faker::Company.name, sponsor_url: "https://google.com")
end
FoodForThought.all.each do |fft|
  ActionText::RichText.create!(record_type: 'FoodForThought', record_id: fft.id, name: 'content', body: Faker::Lorem.sentence)
end

p 'Seed completed'