def populate_precription_has_regimen
  last_updated = get_last_updated('PrescriptionHasRegimen')

<<<<<<< HEAD
  query = "SELECT encounter_id, group_concat(drug_id) drugs,updated_at 
           FROM ids.medication_prescriptions
           WHERE updated_at >= '#{last_updated}'
           AND drug_id IN (SELECT drug_id FROM ids.arv_drugs) group by encounter_id "
    
  fetch_data(query) do |prescription|
     puts "processing Prescription has info for encounter #{prescription['encounter_id']}"

    regimen = MedicationRegimen.where(drug_composition: prescription['drugs']).select('medication_regimen_id').limit(1)
  begin
    prescription_has_reg_exist = MedicationPrescriptionHasMedicationRegimen.find_by(medication_regimen_id: regimen.first['medication_regimen_id'],
                                                                                   medication_prescription_encounter_id: prescription['encounter_id'])

    if prescription_has_reg_exist
      next
    else
      MedicationPrescriptionHasMedicationRegimen.create(medication_prescription_encounter_id: prescription['encounter_id'],
                                                        medication_regimen_id: regimen.first['medication_regimen_id'])
    end
  rescue
  end
    update_last_update('PrescriptionHasRegimen', prescription['updated_at'])
  end
end
=======
  query = <<~SQL 
    SELECT encounter_id, group_concat(drug_id) drugs,updated_at 
           FROM medication_prescriptions
           WHERE updated_at >= '#{last_updated}'
           AND drug_id IN (SELECT drug_id FROM arv_drugs) group by encounter_id
           ORDER BY updated_at 
  SQL

 fetch_data_P(query, 'ids_regimen', 'PrescriptionHasRegimen')
end

def ids_regimen(prescription)
      regimen = MedicationRegimen.where(drug_composition: prescription['drugs']).select('medication_regimen_id').limit(1)
    begin
      prescription_has_reg_exist = MedicationPrescriptionHasMedicationRegimen.find_by(medication_regimen_id: regimen.first['medication_regimen_id'],
                                                                                     medication_prescription_encounter_id: prescription['encounter_id'])

      if prescription_has_reg_exist
        return
      else
        MedicationPrescriptionHasMedicationRegimen.create(medication_prescription_encounter_id: prescription['encounter_id'],
                                                          medication_regimen_id: regimen.first['medication_regimen_id'])
      end
    rescue
    end
end
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
