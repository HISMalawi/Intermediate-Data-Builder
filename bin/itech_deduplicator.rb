require_relative 'bantu_soundex'
@threshold = 0.70
MATCH_TYPES = ['m_sname','f_sname','f_fname']



def main
  count = ItechDeduplication.count
  Parallel.each_with_index(ItechDeduplication.all.select('id,m_fname,m_sname,f_sname,f_fname,dob')) do |person, i|
    print "Processing #{i+1} of #{count} \r"
    MATCH_TYPES.each do | type |
      duplicates = check_duplicates(person,type)
    end
  end
end


def check_duplicates(person,type)
  #Calculate soundex
  return if person[:m_fname].blank? || person[type].blank?
  soundex = calculate_soundex(person[:m_fname], person[type])

  potential_duplicates = PersonName.joins('INNER JOIN soundexes on person_names.person_id = soundexes.person_id
                                           LEFT JOIN people on person_names.person_id = people.person_id')
                                          .where.not({given_name: '',
                                                      family_name: ''})
                                          .where({
                                                  'soundexes.first_name': soundex[:firstname_soundex],
                                                  'soundexes.last_name': soundex[:lastname_soundex],
                                                  'people.voided': false,
                                                  'person_names.voided': false })
                                          .select(:person_id, :given_name,:family_name,:birthdate)
  process_duplicates(potential_duplicates,
                    person,
                    type) unless potential_duplicates.blank?
end

def calculate_soundex(firstname,lastname)

  {
   firstname_soundex: firstname.soundex,
   lastname_soundex: lastname.soundex
  }
end

def process_duplicates(duplicates,demographics,type)
  return if demographics[:m_fname].blank? || demographics[type].blank?

  if demographics[:dob].blank?
    duplicates.each do |duplicate|
          potential_duplicate = (duplicate['given_name'] + duplicate['family_name']).squish
          primary_demographics = (demographics[:m_fname] + demographics[type]).squish

          deduplication({person: primary_demographics,
                         person_id: demographics[:id]
                        },
                        {person: potential_duplicate,
                         person_id: duplicate[:person_id]
                        },
                        type)
    end
  elsif !demographics[:dob].blank?
    duplicates.each do |duplicate|
          potential_duplicate = (duplicate['given_name'] + duplicate['family_name'] +
          duplicate['birthdate'].to_date.strftime('%Y-%m-%d').gsub('-', '')).squish
          primary_demographics = (demographics[:m_fname] + demographics[type] +
          demographics[:dob].to_date.strftime('%Y-%m-%d').gsub('-', '')).squish

          deduplication({person: primary_demographics,
                         person_id: demographics[:id]
                        },
                        {person: potential_duplicate,
                         person_id: duplicate[:person_id]
                        },
                        type)
    end
  end
end

def deduplication(primary_demographics,potential_duplicate,type)
  score = WhiteSimilarity.similarity(primary_demographics[:person],
                                     potential_duplicate[:person])
      if score >= @threshold
        #Save to duplicate_statuses
        ItechPotentialDuplicate.create!(person_a_id: primary_demographics[:person_id],
                                        person_b_id: potential_duplicate[:person_id],
                                        score: (score * 100),
                                        duplicate_type: type) unless
                                        (ItechPotentialDuplicate.find_by(
                                          person_a_id: primary_demographics[:person_id],
                                          person_b_id: potential_duplicate[:person_id],
                                          duplicate_type: type).present?)
      end
end

main
