# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

def load_from_folder(folder)
  Dir[File.join(Rails.root, "db", "seeds", folder, "*.rb")].sort.each do |seed|
    puts "Seeding #{seed}."
    load seed
  end
end

task stage_data: :environment do
  puts "seeding data on stage"
  load_from_folder("development")
end

