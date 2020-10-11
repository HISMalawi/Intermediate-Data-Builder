require 'yaml'
require_relative 'ids_commons'
require_relative 'populate_soundex'

@threshold = 85
@batch_size = 1_000_000
@rds_db = YAML.load_file("#{Rails.root}/config/database.yml")['rds']['database']


def initiate_de_duplication
last_updated = get_last_updated('DeDuplicators')
#Populate Duplicators
  query = "SELECT * FROM #{@rds_db}.person
           ORDER BY updated_at"
  fetch_data_P(query, 'ids_populate_de_duplicators', 'DeDuplicators')

 #Populate soundex
 puts 'Populating soundex values'
 populate_soundex

#Run Deduplication
 puts 'Identifiying Potential Duplicates'
  count = DeDuplicator.count
  last_updated = get_last_updated('DeDuplication')
  DeDuplicator.where('updated_at >= ?', last_updated).order(:updated_at).find_each.with_index do |person,i|
    print "processing #{i+1} / #{count} \r"
    check_for_duplicate(person)
    update_last_update('DeDuplication', person['updated_at']) #Update the updated timestamp
  end
end


def check_for_duplicate(demographics)
  soundex_codes = Soundex.where(person_id: demographics['person_id'])
  puts demographics.inspect
  puts soundex_codes.empty?
  puts soundex_codes.inspect

  unless soundex_codes.empty?
    potential_duplicates = DeDuplicator.joins(:soundex).where(soundexes: {first_name: soundex_codes.first['first_name'],
                                                                 last_name: soundex_codes.first['last_name']})
      
    process_duplicates(potential_duplicates, demographics) unless potential_duplicates.blank?
  else
    `echo "#{demographics['person_id']}," >> #{Rails.root}/log/ids_without_soundex_idz.log`
  end
    
end


def process_duplicates(duplicates, demographics)

  duplicates.each do |duplicate|
      next if demographics['person_id'] == duplicate['person_id']
      next if (PotentialDuplicate.find_by(person_id_a: demographics['person_id'], person_id_b: duplicate['person_id']).present? || 
              PotentialDuplicate.find_by(person_id_a: duplicate['person_id'], person_id_b: demographics['person_id']).present?)

      score = calculate_similarity_score(demographics['person_de_duplicator'],duplicate['person_de_duplicator'])
      if score >= 85
        #Save to duplicate_statuses
        PotentialDuplicate.create(person_id_a: demographics['person_id'], person_id_b: duplicate['person_id'], score: score)
      end
  end
end

def get_rds_person_name(person_id)
 #last_updated = get_last_updated('PersonName')
  person_name = []
  rds_person_name = ActiveRecord::Base.connection.select_all <<QUERY
  SELECT * FROM #{@rds_db}.person_name where person_id = #{person_id} ORDER BY updated_at ;
QUERY
  rds_person_name.each { |name| person_name << name }
end

def get_rds_person_addresses(person_id)
  #last_updated = get_last_updated('PersonAddress')
  person_address = []
  rds_address = ActiveRecord::Base.connection.select_all <<QUERY
  SELECT * FROM #{@rds_db}.person_address where person_id = #{person_id} ORDER BY updated_at;
QUERY

  rds_address.each { |address| person_address << address }
end

def get_rds_person_attributes
  last_updated = get_last_updated('PersonAttribute')
  person_attribute = []
  rds_attribute = ActiveRecord::Base.connection.select_all <<~SQL
    SELECT * FROM #{@rds_db}.person_attribute WHERE (person_attribute_type_id IN (12,14,15)
    AND updated_at >= '#{last_updated}' AND voided = 0)
    OR person_id IN #{load_error_records('person_attribute')} ORDER by updated_at;
  SQL

  rds_attribute.each { |attribute| person_attribute << attribute }
end


def ids_populate_de_duplicators(person)
  demographics = {}
  demographics = { "person": person }
  demographics.update("person_names": get_rds_person_name(person['person_id']))

  return if demographics[:person_names][0]['given_name'].blank? || demographics[:person_names][0]['family_name'].blank? rescue return
  
  #Return if firstname or last name has special Characters assumption is its not a valid name
  return unless  demographics[:person_names][0]['given_name'].match? /\A[a-zA-Z']*\z/ 
  return unless  demographics[:person_names][0]['family_name'].match? /\A[a-zA-Z']*\z/

  demographics.update("person_address": get_rds_person_addresses(person['person_id']))
 
  begin
    subject = ''
    subject += (demographics[:person_names][0]['given_name'] || return)
    subject << demographics[:person_names][0]['family_name'] rescue  return
    subject <<  demographics[:person]['gender'] rescue  return
    subject <<  demographics[:person]['birthdate'].strftime('%Y-%m-%d').gsub('-', '') rescue return
    subject <<  demographics[:person_address][0]['address2'] rescue  return
    subject <<  demographics[:person_address][0]['county_district'] rescue  return
    subject <<  demographics[:person_address][0]['neighborhood_cell'] rescue  return
  rescue StandardError => e
    File.write('log/app_errors.log', e,  mode: 'a')
  end
 
  return if subject.blank?

  begin
    subject.downcase!.gsub!(/[[:space:]]/, '')
  rescue StandardError
    return
  end

  person_present = DeDuplicator.find_by(
    person_id: demographics[:person]['person_id']
  )

  if person_present.blank?
    begin
      DeDuplicator.create(person_id: demographics[:person]['person_id'],
                          person_de_duplicator: subject)
    rescue StandardError => e
      File.write('log/app_errors.log', e,  mode: 'a')
    end
  else
    person_present.update(person_de_duplicator: subject)
  end
end

initiate_de_duplication 