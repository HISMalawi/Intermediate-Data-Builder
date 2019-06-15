# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Creation of other records in Ruby above ...

# Load metadata into database
connection = ActiveRecord::Base.connection
puts "...Loading Database..."
sql = File.read('db/seed_dumps/person_types.sql') # Change path and filename as necessary
statements = sql.split(/;$/)
statements.pop

ActiveRecord::Base.transaction do
  statements.each do |statement|
    connection.execute(statement)
  end
end
puts "...Database Loaded..."


puts "Initialising Nations"

CSV.foreach("#{Rails.root}/app/assets/data/country.csv", :headers => true) do |row|
  Country.count
  next if row[0].blank?
  country = row[3]
  if country.blank?
    country = Country.new()
    country.name = row[3]

    country.save!
    puts "Country Saved"
  else
    country = Country.new()
    country.country_id = row[0]
    country.name = row[3]

    country.save!
    puts "Country:  {#Country.all.name} Saved"
  end

#Other Country
ucountry = "Other"
if ucountry.blank?
  ucountry = Country.new()
  ucountry.name = "Other"
  ucountry.save
else
  puts "Other Country already exists"
end
#Unknown Country
ucountry = "Unknown"
if ucountry.blank?
  ucountry = Country.new()
  ucountry.name = "Unknown"
  ucountry.save
else
  puts "Unknown Country already exists"
end

puts "Country count : #{Country.all.count}"
end

# ending loading metadata into database

# Creation of other records in Ruby below ...