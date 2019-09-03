require 'json'
@lims_url = 'localhost:3010'
@lims_user = 'lab_test'
@lims_pwd = 'lab_test'

def populate_lab_test_results
  token_key = authenticate
  header = {token: token_key}
  lastest_update = LabOrder.maximum('updated_at')

  Parallel.each(LabOrder.all, progress: 'Processing Lab Results') do |lab_order|
    if lab_order['tracking_number'].blank?
       puts 'Skipping Record'
       next
    end
    
    last_updated = get_last_updated('LabTestResults')    

    get_lab_order_details = JSON.parse(RestClient.get("#{@lims_url}/api/v1/query_order_by_tracking_number/#{lab_order['tracking_number']}",
                                           header))
    get_lab_order_results = JSON.parse(RestClient.get("#{@lims_url}/api/v1/query_results_by_tracking_number/#{lab_order['tracking_number']}",
                                                      header))
    if get_lab_order_results['status'] == 200
       get_lab_order_results['data']['results'].each do |measure, value|
         value.each do  | test, v|
              next if test == 'result_date'
              #begin
                  lab_result = LabTestResult.find_by(lab_order_id: lab_order['lab_order_id'])
                if lab_result
                  lab_result.update(lab_order_id: lab_order['lab_order_id'],
                  results_test_facility: (get_lab_order_details['data']['other']['receiving_lab'] rescue 'N/A'),
                  test_type: measure,
                  sample_type: (get_lab_order_details['data']['other']['sample_type'] rescue 'N/A'),
                  test_measure: test,
                  test_result_date: value['result_date'],
                  result: v,
                  app_date_created: Time.now)
                else
                  lab_result = LabTestResult.new
                  lab_result['lab_order_id'] = lab_order['lab_order_id']
                  lab_result['results_test_facility'] = (get_lab_order_details['data']['other']['receiving_lab'] rescue 'N/A')
                  lab_result['test_type'] = measure
                  lab_result['sample_type']  = (get_lab_order_details['data']['other']['sample_type'] rescue 'N/A')
                  lab_result['test_measure'] = test
                  lab_result['test_result_date'] = value['result_date']
                  lab_result['result'] = v
                  lab_result['app_date_created'] = Time.now

                  lab_result.save
                end
              # rescue Exception => e
              #  File.write('log/app_errors.log', e.message, mode: 'a')
              # end
            end
          end
    end
  end
  update_last_update('LabTestResults', lastest_update)
end

def authenticate
  token = JSON.parse((RestClient.get("#{@lims_url}/api/v1/re_authenticate/#{@lims_user}/#{@lims_pwd}")).body)
  return token['data']['token']
end
