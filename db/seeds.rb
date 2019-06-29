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

metadata_sql_files = %w[person_types master_definitions drugs_and_regimens]
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
  next if row[0].blank?

  country = Country.new
  country.name = row[3]
  country.save!
  puts "...#{country.name} Saved Successfully..."
end
puts '========================================================'
puts "======== All : #{Country.count} Countries Saved Successfully ======"
puts '========================================================'
puts '======== Initializing Districts In Malawi ======'
puts '========================================================'
CSV.foreach("#{Rails.root}/app/assets/data/districts_with_codes.csv", headers: true) do |row|
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
puts '========================================================'
puts "======= All : #{Location.count} Districts Saved Successfully ======"
puts '========================================================'
file = File.open("#{Rails.root}/app/assets/data/districts.json").read
json = JSON.parse(file)
puts '======== Initialising TAs  and Their Respective Villages ======='
json.each do |district, traditional_authorities|
  district_id = begin
                  Location.find_by_name(district).location_id
                rescue StandardError
                  nil
                end
  next if district_id.blank?

  traditional_authorities.each do |ta, villages|
    next if ta.blank?

    district_ta = Location.new
    district_ta.parent_location = district_id
    district_ta.name = ta
    district_ta.save!
    ta_id = district_ta.location_id
    villages.each do |village|
      ta_village = Location.new
      ta_village.parent_location = ta_id
      ta_village.name = village
      ta_village.save!
      puts "Village #{ta_village.name} of TA #{district_ta.name} of #{district} Was Saved Successfully"
    end
  end
end
puts '========================================================'
puts '============= TAs and Villages Loaded Successfully ================'
puts '========================================================'
puts '================= Initializing Site Types  =================='
puts '========================================================'
CSV.foreach("#{Rails.root}/app/assets/data/site_types.csv", headers: true) do |row|
  next if row[0].blank?

  site = SiteType.new
  site.site_type = row[0]
  site.description = row[1]
  site.save!
  puts "...#{site.site_type} Saved Successfully..."
end
puts '========================================================'
puts "======== All : #{SiteType.count} Sites Types Saved Successfully ======"
puts '========================================================'
puts '======= Initializing Duplicate Statuses  ======'
puts '========================================================'
CSV.foreach("#{Rails.root}/app/assets/data/duplicate_status.csv", headers: true) do |row|
  next if row[0].blank?

  duplicate = DuplicateStatus.new
  duplicate.status = row[0]
  duplicate.description = row[1]
  duplicate.save!
  puts "...#{duplicate.status} Saved Successfully..."
end
puts '========================================================'
puts "======== All : #{DuplicateStatus.count} Duplicate Statuses Saved Successfully ======"
puts '========================================================'
puts '======= Initializing Health Facilities  ======'
puts '========================================================'
CSV.foreach("#{Rails.root}/app/assets/data/health_facilities.csv", headers: true) do |row|
  next if row[0].blank?

  site = Site.new
  site_type = ''
  site_type = if row[5].downcase.include?('district')
                'District Hospital'
              elsif row[5] == 'Central'
                'Central Hospital'
              else
                'Health Facility'
              end
  site.site_type_id = begin
                        SiteType.find_by_site_type(site_type).site_type_id
                      rescue StandardError
                        nil
                      end
  site.site_name = row[3]
  site.short_name = row[1]
  site.site_description = row[6]
  site.save!
  puts "...#{site.site_name} Saved Successfully..."
end
puts '========================================================'
puts "======== All : #{Site.count} Sites Saved Successfully ======"
puts '========================================================'
puts ''
puts '======== Application Set Up Done Successfully ======'
puts '========================================================'

# ending loading metadata into database

# Creation of other records in Ruby below ...
