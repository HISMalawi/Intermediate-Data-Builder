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
      WHERE updated_at >= '#{last_updated}'
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

def write_to_db(table, columns, data)
  begin
  columns = '(' + columns + ')'
  puts "Loading into #{table}"
  data.chomp!(',')
   ActiveRecord::Base.connection.execute <<~SQL
  SET FOREIGN_KEY_CHECKS=0;
SQL

  ActiveRecord::Base.connection.execute <<~SQL
  REPlACE INTO #{table} 
  #{columns}
  VALUES #{data};
SQL

 ActiveRecord::Base.connection.execute <<~SQL
    SET FOREIGN_KEY_CHECKS=1;
SQL
  puts "Sucessfully Loaded into #{table}"
  rescue Exception => e 
    File.write('log/app_erros.log',e.message,mode: 'a')
    puts "Handled Exception"
    exit
  end
end

def populate_data(query, method, table_name, model, columns)
  last_updated = get_last_updated(model.to_s)
  i = 1
  data = ''
  latest_updated = '1900-01-01'

  fetch_data(query, last_updated) do |data_item|
    latest_updated = data_item['updated_at']
    data += send(method, data_item)
    if (i % @batch_size).zero?
      write_to_db(table_name, columns, data)
      update_last_update(model, latest_updated)
      data = ''
    end
    i += 1
  end
  
  if data
    write_to_db(table_name, columns, data)
    update_last_update(model, latest_updated)
  end
end

def handle_commons(object)

  object['date_voided'].blank? ? object['date_voided'] = 'NULL' : object['date_voided'] = "'#{object['date_voided'].strftime('%Y-%m-%d %H:%M:%S')}'"

  object['date_created'].blank? ? object['date_created'] = 'NULL' : object['date_created'] = "'#{object['date_created'].strftime('%Y-%m-%d %H:%M:%S')}'"

  object['date_changed'].blank? ? object['date_changed'] = 'NULL' : object['date_changed'] = "'#{object['date_changed'].strftime('%Y-%m-%d %H:%M:%S')}'"

  object['voided_by'].blank? ? object['voided_by'] = 'NULL' : object['voided_by'] = object['voided_by']

  return object

end