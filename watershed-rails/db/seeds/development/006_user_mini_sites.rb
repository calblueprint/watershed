mini_site = MiniSite.last

User.all.each do |user|
  user.add_mini_site(mini_site)
  puts "Add #{user.name} to #{mini_site.name}"
end
