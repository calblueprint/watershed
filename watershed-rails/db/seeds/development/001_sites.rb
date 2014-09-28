# Sites

#  latitude    :decimal(10, 6)
#  longitude   :decimal(10, 6)
#  street      :text
#  city        :string(255)
#  state       :string(255)
#  zip_code    :integer

example_site = Site.where(
  name: "Example Site",
  description: "Shoreditch yr brunch, blog raw denim tofu American Apparel umami bicycle rights. Sartorial ennui asymmetrical pug, locavore squid Pitchfork master cleanse mustache. Cliche squid typewriter, DIY selvage aesthetic hoodie bitters distillery. Aesthetic cred Etsy, cardigan salvia tousled PBR&B Tumblr cray VHS lo-fi direct trade iPhone PBR Neutra. Chambray typewriter retro kale chips scenester hella. Whatever tousled wolf American Apparel paleo Blue Bottle. Deep v bitters bespoke before they sold out flexitarian Intelligentsia banh mi gluten-free kitsch Carles.",
  street: "42 Wallaby Way",
  city: "Berkeley",
  state: "CA",
  zip_code: 11111,
  latitude: BigDecimal.new("37.872043"),
  longitude: BigDecimal.new("-122.257830"),
).first_or_create
