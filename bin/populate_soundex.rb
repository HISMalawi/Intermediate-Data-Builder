require_relative 'bantu_soundex'

count = PersonName.count
PersonName.find_each.with_index do |person,i|
	print "Processing #{i+1} / #{count} \r"
	unless Soundex.exists?(:person_id => person.person_id)
		Soundex.create(person_id: person.person_id,
					   first_name: person.given_name.soundex,
					   last_name:  person.family_name.soundex)
    end
end