# frozen_string_literal: true

def person_has_type(type_id, person)
  unless PersonHasType.find_by(person_id: person['person_id'] || person['patient_id'] || person['person_b'], person_type_id: type_id)
    PersonHasType.create(person_id: person['person_id'] || person['patient_id'] || person['person_b'], person_type_id: type_id)
  end
end

def fetch_data(query)
  offset = 0
  begin
    batch = ActiveRecord::Base.connection.select_all <<-SQL
      #{query}
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

def log_error_records(model, record_id, msg)
   record_present = FailedRecord.joins(:failed_record_type).where(
                    failed_record_types: {name: model.to_s},
                    failed_records: {record_id: record_id})
   if record_present.blank?
     FailedRecord.create(failed_record_type_id:
        FailedRecordType.find_by(name: model.to_s).failed_record_type_id.to_i,
                             record_id: record_id.to_i,
                             errr_message: msg) 
   else
    record_present.update(updated_at: Time.now)
   end
end



def load_error_records(model)
  records = FailedRecord.joins(:failed_record_type).where(failed_record_types: {name: model.to_s}).select(:record_id)
 
  if records.count > 0
    arr = []
    records.each{|record| arr << record['record_id']} 
    return "(#{arr.join(',')})"
  else
    return "(0)"
  end
end

def remove_failed_record(model, record_id)
  record = FailedRecord.joins(:failed_record_type).where(
    failed_record_types: { name: model.to_s },
    failed_records: { record_id: record_id }
  )

  record.first.destroy unless record.blank?
end
