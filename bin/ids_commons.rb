# frozen_string_literal: true

def person_has_type(type_id, person)
  unless PersonHasType.find_by(person_id: person['person_id'] || person['patient_id'] || person['person_b'], person_type_id: type_id)
    PersonHasType.create(person_id: person['person_id'] || person['patient_id'] || person['person_b'], person_type_id: type_id)
  end
end

def fetch_data(query, last_updated)
  offset = 0
  begin
    batch = ActiveRecord::Base.connection.select_all <<-SQL
      #{query}
      updated_at >= '#{last_updated}'
      ORDER BY updated_at  
      LIMIT #{@batch_size}
      OFFSET #{offset}
    SQL
    batch.each do |row|
      yield row
    end
    offset += @batch_size
  end until batch.empty?
end

def handle_commons(object)

  object['date_voided'].blank? ? object['date_voided'] = 'NULL' : object['date_voided'] = "'#{object['date_voided'].strftime('%Y-%m-%d %H:%M:%S')}'"

  object['date_created'].blank? ? object['date_created'] = 'NULL' : object['date_created'] = "'#{object['date_created'].strftime('%Y-%m-%d %H:%M:%S')}'"

  object['date_changed'].blank? ? object['date_changed'] = 'NULL' : object['date_changed'] = "'#{object['date_changed'].strftime('%Y-%m-%d %H:%M:%S')}'"

  object['voided_by'].blank? ? object['voided_by'] = 'NULL' : object['voided_by'] = object['voided_by']

  return object

end