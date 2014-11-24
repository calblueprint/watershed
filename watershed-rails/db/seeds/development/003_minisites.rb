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

images = [
  "http://www.foodsystemsnyc.org/files/Cross%20River%20Resevoir_courtesy%20of%20@JoshDickPhoto.com.jpg",
  "http://maxcdn.thedesigninspiration.com/wp-content/uploads/2009/09/cute-animals/02.jpg",
  "http://animals.loepr.com/wp-content/uploads/2013/06/Cute-animals-pictures-41.jpg",
  "http://image.cdnllnwnl.xosnetwork.com/pics33/800/AN/ANJLCPIXOGYUBNC.20130607192302.jpg",
]

images.each do |image_url|
  photo = Photo.create!(
    parent: MiniSite.first,
    image: open(image_url),
  )
end
