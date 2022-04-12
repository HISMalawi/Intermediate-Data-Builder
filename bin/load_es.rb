require 'elasticsearch'

document = Elasticsearch::Client.new log:true
count = DeDuplicator.count
DeDuplicator.find_each.with_index do |person,i|
	print "Processing #{i} / #{count}"
	document.index index: 'de_duplicator', id: person.person_id, body: {
		duplicator: "#{person.person_de_duplicator}"
	}
end