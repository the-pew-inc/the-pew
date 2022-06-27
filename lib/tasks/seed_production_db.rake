namespace :seed_production_db do
  
  desc "Seed Roles in the databse"
  task roles: :environment do
    Role.create!([
      {name: "owner"},     # Owner of an account (there is only one owner per account)
      {name: "admin"},     # Admin of an account (there can be multiple admins in an account)
      {name: "moderator"}, # Moderate the questions in a room or event (when defined at event level, moderate all the rooms under the given event)
      {name: "guest"},     # Guest
      {name: "billing"}    # Manage the billing for a given account (there can be multiple billing users)
      ])

      p "Created #{Role.count} roles"
  end

end
