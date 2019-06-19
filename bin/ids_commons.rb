# frozen_string_literal: true

class IdsCommons
  def person_has_type(type_id, person)
    unless PersonHasType.find_by(person_id: person['person_id'], person_type_id: type_id)
      PersonHasType.create(person_id: person['person_id'], person_type_id: type_id)
    end
  end
end
