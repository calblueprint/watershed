# Field Reports

mini_site_count = MiniSite.count
user_count = User.count

(0..mini_site_count).each do |mini_site_number|
  (0..2).each do |report_number|
    example_field_report = FieldReport.where(
      user_id: rand(0..user_count) + 1,
      mini_site_id: mini_site_number + 1
      description: "This is report #{report_number}. This tree sucks so much.",
      health_rating: rand(0..5) + 1,
      urgent: [true, false].sample
    ).first_or_create
    puts "Created Field Report: Report #{report_number} at Mini Site #{mini_site_number}.
          Created by User #{example_field_report.user_id}"
  end
end