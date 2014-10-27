require "csv"

csv_file = File.join(Rails.root, "db", "seeds", "sites", "import.csv")

CSV.foreach(csv_file, headers: true) do |row|
  puts row
end
