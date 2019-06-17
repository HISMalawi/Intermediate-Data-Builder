# frozen_string_literal: true

require 'yaml'

@rds_db = YAML.load_file("#{Rails.root}/config/database.yml")['rds']['database']
File.open("#{Rails.root}/log/last_update.yml", 'w') unless File.exist?("#{Rails.root}/log/last_update.yml") # Create a tracking file if it does not exist
@last_updated = YAML.load_file("#{Rails.root}/log/last_update.yml")
@batch_size = 50_000
@threshold = 85

def get_all_rds_people
  last_updated = get_last_updated('Person')

  rds_people = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person where created_at >= '#{last_updated}' ORDER BY created_at;
QUERY
end

def get_rds_person_name(person_id)
  @last_updated['PersonName'].blank? ? last_updated = '1900-01-01 00:00:00' : last_updated = @last_updated['PersonName']
  person_name = []
  rds_person_name = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person_name where person_id = #{person_id}
	AND (created_at >= '#{last_updated}');
QUERY
  rds_person_name.each { |name| person_name << name }
end

def get_rds_person_addresses(person_id)
  @last_updated['PersonAddress'].blank? ? last_updated = '1900-01-01 00:00:00' : last_updated = @last_updated['PersonAddress']
  person_address = []
  rds_address = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person_address where person_id = #{person_id}
	AND (date_created >= '#{last_updated}'
	OR date_voided  >=  '#{last_updated}');

QUERY

  rds_address.each { |address| person_address << address }
end

# get person attributes from rds
def get_rds_person_attributes
  @last_updated['PersonAttribute'].blank? ? last_updated = '1900-01-01 00:00:00' : last_updated = @last_updated['PersonAttribute']
  person_attribute = []
  rds_attribute = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person_attribute WHERE person_attribute_type_id IN (12,14,15)
	AND (date_created >= '#{last_updated}'
	OR date_voided  >=  '#{last_updated}');

QUERY

  rds_attribute.each { |attribute| person_attribute << attribute }
end

# get all rds users
def get_rds_users
  if @last_updated.include?('Users')
    @last_updated['Users'].blank? ? last_updated = '1900-01-01 00:00:00' : last_updated = @last_updated['Users']
  else
    last_updated = '1900-01-01 00:00:00'
  end

  rds_users = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.users where date_created >= '#{last_updated}'
	OR date_changed >= '#{last_updated}'
	OR date_voided  >= '#{last_updated}'
  ORDER BY date_created, date_changed, date_voided;

QUERY
end

def find_duplicates(subject, subject_person_id)
  duplicates = ActiveRecord::Base.connection.select_all <<QUERY
			SELECT person_id, ROUND(CAST((((length("#{subject}") - levenshtein(person_de_duplicator,"#{subject}",2))/ length("#{subject}")) * 100) AS DECIMAL),2)
 as score FROM de_duplicators WHERE person_id != #{subject_person_id};
QUERY
end

def process_duplicates(duplicates, duplicate_id)
  duplicates.each do |duplicate|
    if duplicate['score'].to_f >= @threshold
      # save to duplicate_statuses
      PotentialDuplicate.create(person_id_a: duplicate_id, person_id_b: duplicate['person_id'], score: duplicate['score'].to_f)
    end
  end
end

def check_for_duplicate(demographics)
  # find matching text in de_duplicator table
  subject = ''
  begin
    subject << demographics[:person_names][0]['given_name']
  rescue StandardError
    nil
  end
  begin
    subject << demographics[:person_names][0]['family_name']
  rescue StandardError
    nil
  end
  begin
    subject << demographics[:person]['gender']
  rescue StandardError
    nil
  end
  begin
    subject << demographics[:person]['birthdate'].strftime('%Y-%m-%d').gsub('-', '')
  rescue StandardError
    nil
  end
  begin
    subject << demographics[:person_address][0]['address2']
  rescue StandardError
    nil
  end
  begin
    subject << demographics[:person_address][0]['county_district']
  rescue StandardError
    nil
  end
  begin
    subject << demographics[:person_address][0]['neighborhood_cell']
  rescue StandardError
    nil
  end

  duplicates = find_duplicates(subject, demographics[:person]['person_id'])

  person_present = DeDuplicator.find_by(person_id: demographics[:person]['person_id'])
  if person_present
    puts 'person_present'
    person_present.update(person_de_duplicator: subject)
  else
    DeDuplicator.create(person_id: demographics[:person]['person_id'], person_de_duplicator: subject)
    begin
      puts duplicates.first['score'].to_f.inspect
    rescue StandardError
      nil
    end
  end
  process_duplicates(duplicates, demographics[:person]['person_id']) unless duplicates.blank?
end

# populate people in IDS
def populate_people
  get_all_rds_people.each do |person|
    person['birthdate'].blank? ? dob = "'1900-01-01'" : dob = "'#{person['birthdate'].to_date}'"

    person['death_date'].blank? ? dod = 'NULL' : dod = "'#{person['death_date'].to_date}'"

    person['date_voided'].blank? ? voided_date = 'NULL' : voided_date = "'#{person['date_voided'].strftime('%Y-%m-%d %H:%M:%S')}'"

    person['date_created'].blank? ? app_created_at = 'NULL' : app_created_at = "'#{person['date_created'].strftime('%Y-%m-%d %H:%M:%S')}'"

    person['date_changed'].blank? ? app_updated_at = 'NULL' : app_updated_at = "'#{person['date_changed'].strftime('%Y-%m-%d %H:%M:%S')}'"

    gender = person['gender'] == 'M' ? 1 : 0

    puts "processing person_id #{person['person_id']}"

    person_exits = Person.find_by(person_id: person['person_id'])

    if person_exits.blank?
      Person.create(person_id: person['person_id'].to_i, birthdate: dob, birthdate_est: person['birthdate_estimated'].to_i,
                    gender: gender.to_i, death_date: dod, cause_of_death: person['cause_of_death'], dead: person['dead'].to_i,
                    voided: person['voided'].to_i, voided_by: person['voided_by'].to_i, voided_date: voided_date,
                    void_reason: person['void_reason'].to_i, app_date_created: app_created_at, app_date_updated: app_updated_at )
    else
      person_exits.update(birthdate: dob, birthdate_est: person['birthdate_estimated'].to_i,
                    gender: gender.to_i, death_date: dod, cause_of_death: person['cause_of_death'], dead: person['dead'].to_i,
                    voided: person['voided'].to_i, voided_by: person['voided_by'].to_i, voided_date: voided_date,
                    void_reason: person['void_reason'].to_i, app_date_created: app_created_at, app_date_updated: app_updated_at )

      puts 'Updating'
    end
    update_last_update('Person', person['date_created'])
  end
end

def update_last_update(model, timestamp)
  current_update_date = YAML.load_file("#{Rails.root}/log/last_update.yml") || {}
  current_update_date[model] = timestamp.strftime('%Y-%m-%d %H:%M:%S')
  File.open('log/last_update.yml', 'w') do |file|
    file.write current_update_date.to_yaml
  end
end

def initiate_deduplication
  rds_people = get_all_rds_people
  rds_people.each do |person|
    demographics = {}
    demographics = { "person": person }
    demographics.update("person_names": get_rds_person_name(person['person_id']))
    demographics.update("person_address": get_rds_person_addresses(person['person_id']))

    check_for_duplicate(demographics)
  end
end

def populate_personnames
  last_updated = get_last_updated('PersonNames')
  person_names = ActiveRecord::Base.connection.select_all <<SQL
  SELECT * FROM #{@rds_db}.person_name WHERE date_created >= '#{last_updated}' OR date_changed >= '#{last_updated}'
  OR date_voided = '#{last_updated}';
SQL

  person_names.each do |person_name|
    puts "Updating Person Name for person_id: #{person_name['person_id']}"
    person_name_exist = PersonName.find_by(person_name_id: person_name['person_name_id'])

    if person_name_exist.blank?
      PersonName.create(person_name_id: person_name['person_name_id'], person_id: person_name['person_id'],
                        given_name: person_name['given_name'], family_name: person_name['family_name'],
                        middle_name: person_name['middle_name'], maiden_name: person_name['maiden_name'],
                        creator: person_name['creator'], voided: person_name['voided'], voided_by: person_name['voided_by'],
                        void_reason: person_name['void_reason'], app_date_created: person_name['date_created'],
                        app_date_updated: person_name['date_updated'])
    else
      person_name_exist.update(person_name_id: person_name['person_name_id'], person_id: person_name['person_id'],
                               given_name: person_name['given_name'], family_name: person_name['family_name'],
                               middle_name: person_name['middle_name'], maiden_name: person_name['maiden_name'],
                               creator: person_name['creator'], voided: person_name['voided'], voided_by: person_name['voided_by'],
                               void_reason: person_name['void_reason'], app_date_created: person_name['date_created'],
                               app_date_updated: person_name['date_updated'])
    end
    update_last_update('PersonName', person_name['date_created'])
  end
end

# populate contact details in IDS
def populate_contact_details
  get_rds_person_attributes.each do |person_attribute|
    attribute_value = person_attribute['value']

    cell_phone_number = ''
    home_phone_number = ''
    work_phone_number = ''

    case person_attribute['person_attribute_type_id']

    when 12
      cell_phone_number = attribute_value
    when 14
      home_phone_number = attribute_value
    when 15
      work_phone_number = attribute_value

      # TODO Add email address code
      # email_address to be added when applications having email addresses start pushing to IDS
    end

    puts "processing person_id #{person_attribute['person_id']}"

    person = Person.find_by(person_id: person_attribute['person_id'])

    if person
      if ContactDetail.find_by(person_id: person_attribute['person_id']).blank?
        contact_detail = ContactDetail.new
        contact_detail.person_id = person_attribute['person_id']
        contact_detail.home_phone_number = home_phone_number
        contact_detail.cell_phone_number = cell_phone_number
        contact_detail.work_phone_number = work_phone_number
        contact_detail.creator = person_attribute['creator']
        contact_detail.voided = person_attribute['voided']
        contact_detail.voided_by = person_attribute['voided_by']
        contact_detail.voided_date = person_attribute['date_voided']
        contact_detail.void_reason = person_attribute['void_reason']
        contact_detail.created_at = Date.today.strftime('%Y-%m-%d %H:%M:%S')
        contact_detail.updated_at = Date.today.strftime('%Y-%m-%d %H:%M:%S')

        contact_detail.save

        puts "Successfully populated contact details with record for person #{person_attribute['person_id']}"
      else
        contact_detail = ContactDetail.where(person_id: person_attribute['person_id'])
        contact_detail.update(home_phone_number: '') unless home_phone_number.nil?
        contact_detail.update(cell_phone_number: '') unless cell_phone_number.nil?
        contact_detail.update(work_phone_number: '') unless work_phone_number.nil?
        contact_detail.update(creator: person_attribute['creator'])
        contact_detail.update(voided: person_attribute['voided'])
        contact_detail.update(voided_by: person_attribute['voided_by'])
        contact_detail.update(voided_date: person_attribute['date_voided'])
        contact_detail.update(void_reason: person_attribute['void_reason'])
        contact_detail.update(created_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))
        contact_detail.update(updated_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))

        puts "Successfully updated contact details with record for person #{person_attribute['person_id']}"
      end
    else
      puts '==================================================================='
      puts "Skipped record for Person with ID #{person_attribute['person_id']}"
      puts 'Reason: Person records for the above ID not available in People'
      puts '==================================================================='
      puts ''
      puts 'Ending script'
      break
    end
    current_update_date = {}
    current_update_date['PersonAttribute'] = person_attribute['date_created'].strftime('%Y-%m-%d %H:%M:%S')

    File.open('log/last_update.yml', 'w') do |file|
      file.write current_update_date.to_yaml
    end
  end
end

# populate users in IDS
def populate_users
  # person_id, username, user_role
  get_rds_users.each do |rds_user|
    person = Person.find_by(person_id: rds_user['person_id'])

    # TODO code for getting all people skipping user, to talk about this
    if person
      if User.find_by(person_id: rds_user['person_id']).blank?
        user = User.new
        user.person_id = rds_user['person_id']
        user.username = rds_user['username']
        user.password = rds_user['password']
        user.user_role = ''
        user.save
      end
    else
      puts '==================================================================='
      puts "Skipped record for User with ID #{rds_user['person_id']}"
      puts 'Reason: Person records for the above ID not available in People'
      puts '==================================================================='
      puts ''
      puts 'Ending script'
      break
    end
  end
end

def populate_encounters
  encounters = ActiveRecord::Base.connection.select_all <<SQL
  SELECT * FROM #{@rds_db}.encounter
SQL

  encounters.each do |encounter|
    raise encounter.inspect
  end
end

def get_last_updated(model)
  if @last_updated
    if @last_updated.include?(model)
       @last_updated[model].blank? ? last_updated = '1900-01-01 00:00:00' : last_updated = @last_updated[model]
    else
      last_updated = '1900-01-01 00:00:00'
    end
  else
    last_updated = '1900-01-01 00:00:00'
  end
end

def update_person_type

#Updating users type in person_type table
  last_updated = get_last_updated('User')

  users = ActiveRecord::Base.connection.select_all <<SQL
  SELECT * FROM #{@rds_db}.users WHERE date_created >= '#{last_updated}'
  OR date_changed >= '#{last_updated}' OR date_retired >= '#{last_updated}';
SQL
  users.each do |user|
    PersonHasType.create(person_id: user['person_id'], person_type_id: 4) unless PersonHasType.find_by(person_id: user['person_id'],person_type_id: 4)
    update_last_update('User', user['date_created'])
  end

#Updating Guardians in person type table

  last_updated = get_last_updated('Relationship')

  guardians = ActiveRecord::Base.connection.select_one <<SQL
  SELECT * FROM #{@rds_db}.relationship WHERE date_created >= '#{last_updated}'
  AND relationship = 6;
SQL

  guardians.each do |guardian|
    PersonHasType.create(person_id: guardian['person_id'], person_type_id: 5) unless PersonHasType.find_by(person_id: guardian['person_id'],person_type_id: 5)
    update_last_update('Relationship', guardian['date_created'])
  end

#Updating Guardians in person type table
  last_updated = get_last_updated('Patient')

  patients = ActiveRecord::Base.connection.select_one <<SQL
  SELECT * FROM #{@rds_db}.patient WHERE date_created >= '#{last_updated}'
  OR date_changed >= '#{last_updated}' OR date_voided >= '#{last_updated}';
SQL

  patients.each do |patient|
    PersonHasType.create(person_id: patient['person_id'], person_type_id: 1) unless PersonHasType.find_by(person_id: patient['person_id'],person_type_id: 1)
    update_last_update('Relationship', patient['date_created'])
  end
end

def get_district_id(district)
  Location.find_by(name: district)['location_id'].to_i
end

def populate_person_address
  last_updated = get_last_updated('PersonAddress')

  person_addresses = ActiveRecord::Base.connection.select_all <<SQL
  SELECT * FROM #{@rds_db}.person_address WHERE updated_at >= '#{last_updated}' order by updated_at;
SQL
  person_addresses.each do |person_address|
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Need to add code to get elements from master definition table
  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    #grouped_address = categorize_address(person_address)
    puts "Updating Person Address for person_id: #{person_address['person_id']}"


    person_address_exist = PersonAddress.find_by(person_address_id: person_address['person_address_id'])

    if person_address_exist.blank?
      PersonAddress.create(person_id: person_address['person_id'],
                           home_district_id: 1, home_traditional_authority_id: 1, home_village_id: 1,country_id: 1,
                           current_district_id: 1, current_traditional_authority_id: 1, current_village_id: 1,country_id: 1,
                           creator: person_address['creator'], landmark: person_address['landmark'],
                           app_date_created: person_address['date_created'], app_date_updated: person_address['date_changed'])
    else
      person_address_exist.update( home_district_id: 1, home_traditional_authority_id: 1, home_village_id: 1,country_id: 1,
                                   current_district_id: 1, current_traditional_authority_id: 1, current_village_id: 1,country_id: 1,
                                   creator: person_address['creator'], landmark: person_address['landmark'],
                                   app_date_created: person_address['date_created'], app_date_updated: person_address['date_changed'])
    end
    update_last_update('PersonAddress', person_address['updated_at'])
  end

end
#populate_people # load person records into IDS
#update_person_type
# initiate_deduplication # initate deduplication on people
# populate_contact_details # load contact details
#populate_encounters
#populate_personnames
populate_person_address