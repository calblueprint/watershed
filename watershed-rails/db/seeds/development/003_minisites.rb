(0..20).each do |number|
  example_minisite = MiniSite.where(
    name: "Example Minisite #{number}",
    description: "Hello this is a minisite which is like a site but mini. Ha ha ha.",
    street: "1 Small Way",
    city: "TinyCity",
    state: "CA",
    zip_code: 81881,
    latitude: BigDecimal.new("10.12345"),
    longitude: BigDecimal.new("-43.21098"),
    site_id: number + 1,
  ).first_or_create

  puts "Created Minisite: #{example_minisite.name}"
end

