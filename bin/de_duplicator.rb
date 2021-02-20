require 'yaml'
require_relative 'ids_commons'
require_relative 'populate_soundex'

@threshold = 85
@batch_size = 1_000_000


def initiate_de_duplication
last_updated = get_last_updated('DeDuplicators')
time = Time.now.strftime('%Y-%m-%d %H:%M')
#Populate Duplicators
  query = "SELECT * FROM people WHERE 
           (created_at >= '#{last_updated}' OR updated_at >= '#{last_updated}')
           AND (created_at <= '#{time}' OR updated_at <= '#{time}')
           ORDER BY updated_at"
 #Person.all.each { |person| ids_populate_de_duplicators person}
 fetch_data_P(query, 'ids_populate_de_duplicators', 'DeDuplicators')

 #Populate soundex
 puts 'Populating soundex values'
 populate_soundex(get_last_updated('Soundex'),time)

#Run Deduplication
 puts 'Identifiying Potential Duplicates'
  last_updated = get_last_updated('DeDuplication')
  
  count = DeDuplicator.where('updated_at >= ? AND updated_at <= ?', last_updated, time).count
  
  DeDuplicator.where('updated_at >= ? AND updated_at <= ?', last_updated, time).order(:updated_at).find_each.with_index do |person,i|
    print "processing #{i+1} / #{count} \r"
    check_for_duplicate(person)
    update_last_update('DeDuplication', person['updated_at']) #Update the updated timestamp
  end
end


def check_for_duplicate(demographics)
  soundex_codes = Soundex.where(person_id: demographics['person_id'])

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
      if score >= @threshold.to_i
        #Save to duplicate_statuses
        PotentialDuplicate.create(person_id_a: demographics['person_id'], person_id_b: duplicate['person_id'], score: score)
      end
  end
end

def get_person_names(person_id)
  person_name = []
  person_names = PersonName.where(person_id: person_id).order(:updated_at)
  person_names.each { |name| person_name << name }
end

def get_person_addresses(person_id)
  #last_updated = get_last_updated('PersonAddress')
  person_address = []
  person_addresses = PersonAddress.where(person_id: person_id).order(:updated_at)

  person_addresses.each { |address| person_address << address }
end

def ids_populate_de_duplicators(person)
  demographics = {}
  demographics = { "person": person }
  (get_person_names(person['person_id']) || []).each do |name|
    demographics.update("person_name": name)

    return if demographics[:person_name]['given_name'].blank? || demographics[:person_name]['family_name'].blank? rescue return
    
    #Return if firstname or last name has special Characters assumption is its not a valid name
    return unless  demographics[:person_name]['given_name'].match? /\A[a-zA-Z']*\z/ 
    return unless  demographics[:person_name]['family_name'].match? /\A[a-zA-Z']*\z/
    
    (get_person_addresses(person['person_id']) || []).each do | address |
      demographics.update("person_address": address )
      begin
        subject = ''
        subject += (demographics[:person_name]['given_name'] || return)
        subject << demographics[:person_name]['family_name'] rescue  return
        subject <<  (demographics[:person]['gender'] == 1 ? 'M' : 'F') rescue  return
        subject <<  demographics[:person]['birthdate'].strftime('%Y-%m-%d').gsub('-', '') rescue return
        subject <<  demographics[:person_address]['home_district_id'] rescue  return #home district
        subject <<  demographics[:person_address]['home_traditional_authority_id'] rescue  return #home TA
        subject <<  demographics[:person_address]['home_village_id'] rescue  return #Home village
      rescue StandardError => e
        File.write('log/app_errors.log', e,  mode: 'a')
      end
     
      return if subject.blank?

      begin
        subject.downcase!.gsub!(/[[:space:]]/, '')
      rescue StandardError
        return
      end
      DeDuplicator.find_or_create_by!(person_id: demographics[:person]['person_id'],
                              person_de_duplicator: subject.squish)
        
    end
  end  
end

initiate_de_duplication 