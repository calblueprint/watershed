require "csv"

csv_file = File.join(Rails.root, "db", "seeds", "sites", "import.csv")

CSV.foreach(csv_file, headers: true) do |row|
  site_name, date_planted, address_number, street, common_name_1, common_name_2, common_name_3, species_name_1, species_name_2, species_name_3, latitude, longitude = row.to_a
  puts site_name
end
