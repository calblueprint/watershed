# Users

managers = [
  ["Mark Miyashita", "mark@mark.com"],
]

random_users = (0..20).collect { |number| ["User Number #{number}", "user#{number}@user.com"] }

def create_users(users_info, role)
  users_info.each do |user_info|
    name, email = user_info
    unless User.exists?(email: email)
      new_user = User.create(
        name: name,
        email: email,
        password: "password",
        role: User.roles[role],
      )
      puts "Created user: #{new_user.name}."
    end
  end
end

create_users(managers, :manager)
create_users(random_users, :employee)

