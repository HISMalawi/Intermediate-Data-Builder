def populate_lab_orders
  last_updated = get_last_updated('LabOrders')

  query = "SELECT * FROM #{@rds_db}.orders 
           WHERE (ORDER_TYPE_ID = 4
           AND updated_at >= '#{last_updated}')
           OR order_id IN #{load_error_records('lab_orders')} "

  fetch_data(query) do |lab_order|
    ids_lab_orders(lab_order)
  end
end

def ids_lab_orders(lab_order)

  puts "Processing LabOrder for Person_id: #{lab_order['patient_id']}"
    lab_order_exist = LabOrder.find_by(lab_order_id: lab_order['order_id'])

    if lab_order_exist && check_latest_record(lab_order, lab_order_exist)
      lab_order_exist.update(tracking_number: lab_order['accession_number'], order_date: lab_order['start_date'],
                             encounter_id: lab_order['encounter_id'], creator: lab_order['creator'],
                             voided: lab_order['voided'], voided_by: lab_order['voided_by'],
                             voided_date: lab_order['voided_date'], void_reason: lab_order['void_reason'],
                             app_date_created: lab_order['date_created'], app_date_updated: lab_order['date_changed'],
                             updated_at: Time.now)
    elsif lab_order_exist.blank?
      begin
        LabOrder.create(lab_order_id: lab_order['order_id'], tracking_number: lab_order['accession_number'],
                        order_date: lab_order['start_date'], encounter_id: lab_order['encounter_id'],
                        creator: lab_order['creator'], voided: lab_order['voided'],
                        voided_by: lab_order['voided_by'], voided_date: lab_order['voided_date'],
                        void_reason: lab_order['void_reason'], app_date_created: lab_order['date_created'],
                        app_date_updated: lab_order['date_changed'], created_at: Time.now, updated_at: Time.now)

          remove_failed_record('lab_orders', lab_order['order_id'].to_i)
      rescue Exception => e
        log_error_records('lab_orders', lab_order['order_id'].to_i, e)
      end
    end
  update_last_update('LabOrders', lab_order['updated_at'])
end
