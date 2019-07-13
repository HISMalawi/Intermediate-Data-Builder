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
  puts "Loading into #{table}"
  data.chomp!(',')
  ActiveRecord::Base.connection.execute <<~SQL
  REPlACE INTO #{table} 
  #{columns}
  VALUES #{data};
SQL
  puts "Sucessfully Loaded into #{table}"
end