# frozen_string_literal: true

def ids_relationship(relation)
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

      remove_failed_record('relationships', relation['relationship_id'].to_i)
    rescue Exception => e
      log_error_records('relationships', relation['relationship_id'].to_i, e)
    end
  elsif check_latest_record(relation, relationship)
    relationship_exits.update(
      person_id_a: relation['person_a'],
      person_id_b: relation['person_b'],
      relationship_type_id: relationship_type,
      creator: relation['creator'],
      voided: relation['voided'],
      voided_by: relation['voided_by'],
      voided_date: relation['date_voided'])
  end
end
