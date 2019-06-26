# frozen_string_literal: true

def ids_relationship(relation)
  relationship = Relationship.where(person_id_a: '').where(person_id_b: '').first

  relationship_type = get_master_def_id(relation['relationship'], 'relationship_type')

  if relationship
    relationsip.update(person_id_a: relation['person_a'])
    relationsip.update(person_id_b: relation['person_b'])
    relationsip.update(relationship_type_id: relationship_type)
    relationsip.update(creator: relation['creator'])
    relationsip.update(voided: relation['voided'])
    relationsip.update(voided_by: relation['voided_by'])
    relationsip.update(voided_date: relation['date_voided'])
    'update relationship'
  else
    relationsip = Relationship.new
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

  end
  update_last_update('Relationship', relation['date_created'])
end
