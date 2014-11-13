mini_site = MiniSite.first

User.all.each do |user|
  user.add_mini_site(mini_site)
  puts "Add #{user.name} to #{mini_site.name}"
end
