# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Creation of other records in Ruby above ...

# Load metadata into database
puts '================ Loading SQL Metadata ====================='

metadata_sql_files = %w(person_types master_definitions)
connection = ActiveRecord::Base.connection
(metadata_sql_files || []).each do |metadata_sql_file|
  puts "Loading #{metadata_sql_file} metadata sql file"
  sql = File.read("db/seed_dumps/#{metadata_sql_file}.sql")
  statements = sql.split(/;$/)
  statements.pop

  ActiveRecord::Base.transaction do
    statements.each do |statement|
      connection.execute(statement)
    end
  end
  puts "Loaded #{metadata_sql_file} metadata sql file successfully"
  puts ''
end

puts '================= SQL Metadata End ====================='
puts ''
puts ''
puts '================= Initializing Countries ========================'

CSV.foreach("#{Rails.root}/app/assets/data/country.csv", headers: true) do |row|
  Country.count
  next if row[0].blank?

  country = row[3]
  if country.blank?
    country = Country.new
    country.name = row[3]
    country.save!
    puts 'New Country Saved'
  else
    country = Country.new
    country.country_id = row[0]
    country.name = row[3]
    country.save!
    puts "...#{country.name} Saved Successfully..."
  end

  # Other Country
  ucountry = 'Other'
  if ucountry.blank?
    ucountry = Country.new
    ucountry.name = 'Other'
    ucountry.save
    end
  # Unknown Country
  ucountry = 'Unknown'
  if ucountry.blank?
    ucountry = Country.new
    ucountry.name = 'Unknown'
    ucountry.save
    end
end
puts ''
puts "======== All : #{Country.count} Countries Saved Successfully ======"
puts '========================================================'
# ending loading metadata into database

# Creation of other records in Ruby below ...
