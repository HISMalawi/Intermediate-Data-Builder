def populate_lab_orders
  last_updated = get_last_updated('LabOrders')
  failed_records = load_error_records('LabOrders')

  query = "SELECT * FROM #{@rds_db}.orders 
           WHERE ORDER_TYPE_ID = 4
           order_id IN #{failed_records}
           OR updated_at "

  fetch_data(query, last_updated) do |lab_order|
    ids_lab_orders(lab_order, failed_records)
  end
end

def ids_lab_orders(lab_order, failed_records)

  puts "Populating LabOrder for Person_id: #{lab_order['patient_id']}"
    lab_order_exist = LabOrder.find_by(lab_order_id: lab_order['order_id'])

    if lab_order_exist
      lab_order_exist.update(tracking_number: lab_order['accession_number'], order_date: lab_order['start_date'],
                             encounter_id: lab_order['encounter_id'], creator: lab_order['creator'],
                             voided: lab_order['voided'], voided_by: lab_order['voided_by'],
                             voided_date: lab_order['voided_date'], void_reason: lab_order['void_reason'],
                             app_date_created: lab_order['date_created'], app_date_updated: lab_order['date_changed'],
                             updated_at: Time.now)
    else
      begin
        LabOrder.create(lab_order_id: lab_order['order_id'], tracking_number: lab_order['accession_number'],
                        order_date: lab_order['start_date'], encounter_id: lab_order['encounter_id'],
                        creator: lab_order['creator'], voided: lab_order['voided'],
                        voided_by: lab_order['voided_by'], voided_date: lab_order['voided_date'],
                        void_reason: lab_order['void_reason'], app_date_created: lab_order['date_created'],
                        app_date_updated: lab_order['date_changed'], created_at: Time.now, updated_at: Time.now)

        if failed_records.include?(lab_order['order_id'].to_s)
          remove_failed_record('LabOrders', lab_order['order_id'])
        end
      rescue Exception => e
        File.write('log/app_errors.log', e.message, mode: 'a')
        log_error_records('LabOrders', lab_order['order_id'].to_i)
      end
    end
  update_last_update('LabOrders', lab_order['updated_at'])
end
