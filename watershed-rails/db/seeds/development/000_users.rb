# Users

managers = [
  ["Mark Miyashita", "mark@mark.com"],
]

employees = (0..20).collect { |number| ["Employee Number #{number}", "employee#{number}@watershed.com"] }

community_members = (0..20).collect { |number| ["CM Number #{number}", "member#{number}@watershed.com"] }

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
# create_users(employees, :employee)
create_users(community_members, :community_member)
