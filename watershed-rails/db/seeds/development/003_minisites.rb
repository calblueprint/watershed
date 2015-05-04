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

first_site = Site.first

(0..5).each do |number|
  mini_site_for_first_site = MiniSite.where(
    name: Faker::Commerce.department,
    description: Faker::Lorem.paragraph,
    street: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    zip_code: Faker::Address.zip_code,
    latitude: BigDecimal.new(Faker::Address.latitude),
    longitude: BigDecimal.new(Faker::Address.longitude),
    site_id: first_site.id,
  ).first_or_create

  puts "Created Mini Site for Site: #{first_site.name}"
end

images = [
  # "http://www.foodsystemsnyc.org/files/Cross%20River%20Resevoir_courtesy%20of%20@JoshDickPhoto.com.jpg",
  "http://miriadna.com/desctopwalls/images/max/Ideal-landscape.jpg",
  "http://s.hswstatic.com/gif/landscape-photography-1.jpg",
  "http://image.cdnllnwnl.xosnetwork.com/pics33/800/AN/ANJLCPIXOGYUBNC.20130607192302.jpg",
]

mini_sites_with_images = MiniSite.all

mini_sites_with_images.each do |mini_site|
  images.each do |image_url|
    photo = Photo.create!(
      parent: mini_site,
      image: open(image_url),
    )
  end
end
