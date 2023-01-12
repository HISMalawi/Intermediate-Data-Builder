require_relative 'bantu_soundex'
#Need to modify to accomodate soundex values for persons that have changed only
def populate_soundex(last_updated,current_datetime,count)
	last_update = PersonName.where('updated_at >= ? AND updated_at <= ?', last_updated, current_datetime).maximum(:updated_at)

	PersonName.where('updated_at >= ? AND updated_at <= ?', last_updated, current_datetime)
	.select(:person_id, :given_name, :family_name).distinct(:person_id).find_in_batches(batch_size: @batch_size) do |batch|
		Parallel.each(batch, progress: 'Populating soundex') do |person|
			#print "Processing #{i+1} / #{count} \r"
			next unless DeDuplicator.exists?(person_id: person.person_id) #skip if corresponding duplicator does not exist.
			next if person.given_name.blank? || person.family_name.blank?
			begin
				Soundex.find_or_create_by(person_id: person.person_id,first_name: person.given_name.soundex,
								last_name:  person.family_name.soundex)
			rescue => e
				File.write("#{Rails.root}/log/soundex_errors.log", e, mode: 'a')
				next
			end
		end
	end
    update_last_update('Soundex', last_update) #Update the updated timestamp from the source 
end
