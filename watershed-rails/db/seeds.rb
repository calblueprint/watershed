# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

managers = [
  ["Mark Miyashita", "mark@mark.com"],
]

def create_users(users_info, role)
  users_info.each do |user_info|
    name, email = user_info
    unless User.exists?(email: email)
      new_user = User.create(
        name: name,
        email: email,
        password: "password",
      )
      puts "Created user: #{new_user.name}."
    end
  end
end

create_users(managers, "manager")
