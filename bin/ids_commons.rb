# frozen_string_literal: true

require "damerau-levenshtein"

def person_has_type(type_id, person)
  case type_id
  when 1
    model = 'patient'
  when 2  
    model = 'provider'
  when 3 
    model = 'client'
  when 4
    model = 'user'
  when 5
    model = 'guardian'
  end

  unless PersonHasType.find_by(person_id: person['person_id'] ||
                      person['patient_id'] ||
                      person['person_b'],
                      person_type_id: type_id)
    begin
      PersonHasType.create(person_id: person['person_id'] ||
                           person['patient_id'] ||
                           person['person_b'],
                           person_type_id: type_id)

      remove_failed_record(model, (person['person_id'] ||
                                   person['patient_id'] ||
                                   person['person_b']))
    rescue Exception => e
      log_error_records(model, ((person['person_id'] ||
                                   person['patient_id'] ||
                                   person['person_b'])).to_i, e)
    end
  end
end

def fetch_data_P(query, method, model)
  offset = 0
  begin
    batch = ActiveRecord::Base.connection.select_all <<-SQL
      #{query}
      LIMIT #{@batch_size}
      OFFSET #{offset}
    SQL
    Parallel.each(batch, progress: "Processing #{model} From #{offset} to #{offset + @batch_size}") do |row|
      send(method, row)
    end
    update_last_update(model, batch.last['updated_at']) unless batch.empty?

    offset += @batch_size
  end until batch.empty?
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
    record_present.update(failed_record_type_id:
        FailedRecordType.find_by(name: model.to_s).failed_record_type_id.to_i,
                             record_id: record_id.to_i,
                             errr_message: msg,
                             updated_at: Time.now)
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

def check_latest_record(src, des)
  (src['date_changed'] || src['date_created']).to_date >
  (des['app_date_updated'] || des['app_date_created']).to_date rescue false
end

def update_record(concept_id, value_coded, record, update)
  record.update(
      concept_id: concept_id,
      encounter_id: update['encounter_id'],
      value_coded: value_coded,
      voided: update['voided'],
      voided_by: update['voided_by'],
      voided_date: update['date_voided'],
      void_reason: update['void_reason'],
      app_date_created: update['date_created'],
      app_date_updated: update['date_changed'])
end

def calculate_similarity_score(string_A,string_B)
    #Calulating % Similarity using the formula %RSD = (SD/max_ed)%
    #Where SD = Max(length(A),Length(B)) - Edit Distance

    ed = DamerauLevenshtein.distance(string_A,string_B)

    if string_A.size >= string_B.size
      max_ed = string_A.size
    else 
      max_ed = string_B.size
    end

    sd = max_ed - ed

    score = (sd/max_ed.to_f) * 100
end
