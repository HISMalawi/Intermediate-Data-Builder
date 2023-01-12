# frozen_string_literal: true

def ids_relationship(relation)
<<<<<<< HEAD
  puts "processing Relationship for person ID #{relation['person_id_a']}"

  relationship = Relationship.find_by_relationship_id(relation['relationship_id'])

  relationship_type = get_master_def_id(relation['relationship'], 'relationship_type')

  if relationship && check_latest_record(relation, relationship)
    relationsip.update(person_id_a: relation['person_a'],
                       person_id_b: relation['person_b'],
                       relationship_type_id: relationship_type,
                       creator: relation['creator'],
                       voided: relation['voided'],
                       voided_by: relation['voided_by'],
                       voided_date: relation['date_voided'])
    'update relationship'
    
  elsif relationship.blank?
    begin
      relationsip = Relationship.new
      relationship.relationship_id = relation['relationship_id']
      relationsip.person_id_a = relation['person_a']
      relationsip.person_id_b = relation['person_b']
      relationsip.relationship_type_id = relationship_type
      relationsip.creator = relation['creator']
      relationsip.voided = relation['voided']
      relationsip.voided_by = relation['voided_by']
      relationsip.voided_date = relation['date_voided']
      relationsip.app_date_created = relation['date_created']

      if relationsip.save
        puts 'created relationship'
        remove_failed_record('relationships', relation['relationship_id'].to_i)
      else
        puts 'Failed to create relationship'
      end

    rescue Exception => e
      log_error_records('relationships', relation['relationship_id'].to_i, e)
    end

  end
  update_last_update('Relationship', relation['updated_at'])
=======
  relationship_exits = Relationship.find_by_relationship_id(relation['relationship_id'])

  relationship_type = get_master_def_id(relation['relationship'], 'relationship_type')

  if relationship_exits.blank?
    begin
      relationship = Relationship.new
      relationship.relationship_id = relation['relationship_id']
      relationship.person_id_a = relation['person_a']
      relationship.person_id_b = relation['person_b']
      relationship.relationship_type_id = relationship_type
      relationship.creator = relation['creator']
      relationship.voided = relation['voided']
      relationship.voided_by = relation['voided_by']
      relationship.voided_date = relation['date_voided']
      relationship.app_date_created = relation['date_created']

      relationship.save

      remove_failed_record('relationships', relation['relationship_id'].to_i)
    rescue Exception => e
      log_error_records('relationships', relation['relationship_id'].to_i, e)
    end
  elsif check_latest_record(relation, relationship_exits)
    relationship_exits.update(
      person_id_a: relation['person_a'],
      person_id_b: relation['person_b'],
      relationship_type_id: relationship_type,
      creator: relation['creator'],
      voided: relation['voided'],
      voided_by: relation['voided_by'],
      voided_date: relation['date_voided'])
  end
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
end
