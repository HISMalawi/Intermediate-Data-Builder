require_relative 'bantu_soundex'
#Need to modify to accomodate soundex values for persons that have changed only
def populate_soundex(last_updated,current_datetime)
	count = PersonName.where('updated_at >= ? AND updated_at <= ?', last_updated, current_datetime).count

	last_update = PersonName.where('updated_at >= ? AND updated_at <= ?', last_updated, current_datetime).maximum(:updated_at)

	PersonName.where('updated_at >= ? AND updated_at <= ?', last_updated, current_datetime).each_with_index do |person,i|
		print "Processing #{i+1} / #{count} \r"
		next unless DeDuplicator.exists?(person_id: person.person_id) #skip if corresponding duplicator does not exist.

		person_soundex = Soundex.where(person_id: person.person_id)
        
        if person_soundex.blank?
        	Soundex.create!(person_id: person.person_id,
						   first_name: person.given_name.soundex,
						   last_name:  person.family_name.soundex)
        else
        	person_soundex.update(first_name: person.given_name.soundex,
						          last_name:  person.family_name.soundex)
        end
	end
    update_last_update('Soundex', last_update) #Update the updated timestamp from the source 
end