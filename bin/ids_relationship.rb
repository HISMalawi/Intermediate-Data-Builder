# frozen_string_literal: true

def ids_relationship(relation, failed_records)
  relationship = Relationship.find_by(relation: relation['relationship_id'])

  relationship_type = get_master_def_id(relation['relationship'], 'relationship_type')

  if relationship
    relationsip.update(person_id_a: relation['person_a'],
                       person_id_b: relation['person_b'],
                       relationship_type_id: relationship_type,
                       creator: relation['creator'],
                       voided: relation['voided'],
                       voided_by: relation['voided_by'],
                       voided_date: relation['date_voided'])
    'update relationship'
  else
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
      else
        puts 'Failed to create relationship'
      end

      if failed_records.include?(relation['relationship_id'].to_s)
        remove_failed_record('Relationship', relation['relationship_id'])
      end
    rescue Exception => e
      File.write('log/app_errors.log', e.message, mode: 'a')
      log_error_records('Relationship', relation['relationship_id'].to_i)
    end

  end
  update_last_update('Relationship', relation['date_created'])
end
