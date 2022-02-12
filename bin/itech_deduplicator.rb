require_relative 'bantu_soundex'
@threshold = 0.85
MATCH_TYPES = ['m_sname','f_sname','f_fname']



def main
  count = ItechDeduplication.count
  ItechDeduplication.all.each_with_index do |person, i|
    print "Processing #{i+1} of #{count} \r"
    MATCH_TYPES.each do | type |
      duplicates = check_duplicates(person[:m_fname], person[type],type,person[:id])
    end
  end
end


def check_duplicates(firstname,lastname,type,person_id)
  #Calculate soundex
  return if firstname.blank? || lastname.blank?
  soundex = calculate_soundex(firstname, lastname)

  potential_duplicates = PersonName.joins('INNER JOIN soundexes on person_names.person_id = soundexes.person_id')
                                          .where(soundexes: {first_name: soundex[:firstname_soundex],
                                                             last_name: soundex[:lastname_soundex]})
  process_duplicates(potential_duplicates,
                    {firstname: firstname, lastname: lastname, id: person_id},
                    type) unless potential_duplicates.blank?
end

def calculate_soundex(firstname,lastname)

  {
   firstname_soundex: firstname.soundex,
   lastname_soundex: lastname.soundex
  }
end

def process_duplicates(duplicates, demographics,type)

  duplicates.each do |duplicate|
      potential_duplicate = (duplicate['given_name'] + duplicate['family_name']).squish
      primary_demographics = (demographics[:firstname] + demographics[:lastname]).squish

      score = WhiteSimilarity.similarity(primary_demographics,
                                         potential_duplicate)
      if score >= @threshold
        #Save to duplicate_statuses
        ItechPotentialDuplicate.create!(person_a_id: demographics[:id],
                                        person_b_id: duplicate['person_id'],
                                        score: (score * 100),
                                        duplicate_type: type) unless (ItechPotentialDuplicate.find_by(person_a_id: demographics[:id],
                                               person_b_id: duplicate['person_id'],
                                               duplicate_type: type).present?)
      end
  end
end

main
