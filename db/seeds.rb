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

CSV.foreach("#{Rails.root}/app/assets/data/country.csv", :headers => true) do |row|

  next if row[0].blank?
    country = Country.new
    country.name = row[3]
    country.save!
    puts "...#{country.name} Saved Successfully..."
  end
puts "========================================================"
puts "======== All : #{Country.count} Countries Saved Successfully ======"
puts "========================================================"
puts "======== Initializing Districts In Malawi ======"
puts "========================================================"
CSV.foreach("#{Rails.root}/app/assets/data/districts_with_codes.csv", :headers => true) do |row|
 # Location.count
  next if row[0].blank?
  row[1] = 'Nkhata-bay' if row[1].match(/Nkhata/i)
    location = Location.new
    location.name = row[1]
    location.latitude = row[3]
    location.longitude = row[4]
    location.save!
    puts "...#{location.name} Saved Successfully..."
end
puts "========================================================"
puts "======= All : #{Location.count} Districts Saved Successfully ======"
puts "========================================================"
puts "======= Initializing Site Types  ======"
puts "========================================================"
CSV.foreach("#{Rails.root}/app/assets/data/site_types.csv", :headers => true) do |row|
  next if row[0].blank?
  site = SiteType.new
  site.site_type = row[0]
  site.description = row[1]
  site.save!
  puts "...#{site.site_type } Saved Successfully..."
end
puts "========================================================"
puts "======== All : #{SiteType.count} Sites Types Saved Successfully ======"
puts "========================================================"
puts "======= Initializing Duplicate Statuses  ======"
puts "========================================================"
CSV.foreach("#{Rails.root}/app/assets/data/duplicate_status.csv", :headers => true) do |row|
  next if row[0].blank?
    duplicate = DuplicateStatus.new
    duplicate.status =  row[0]
    duplicate.description = row[1]
    duplicate.save!
    puts "...#{duplicate.status} Saved Successfully..."
end
puts "========================================================"
puts "======== All : #{DuplicateStatus.count} Duplicate Statuses Saved Successfully ======"
puts "========================================================"

# ending loading metadata into database

# Creation of other records in Ruby below ...
