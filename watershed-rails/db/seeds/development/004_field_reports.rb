# Field Reports

(0..20).each do |number|
  example_field_report = FieldReport.where(
    user_id:
    mini_site_id:
    description:
    health_rating:
    urgent:
  ).first_or_create

  puts "Created Field Report: #{example_field_report.urgent}"
end