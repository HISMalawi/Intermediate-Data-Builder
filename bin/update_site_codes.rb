
@rds_db = YAML.load_file("#{Rails.root}/config/database.yml")['rds']['database']

locations = ActiveRecord::Base.connection.select_all <<~SQL
  SELECT location_id, name FROM #{@rds_db}.location;
SQL

Parallel.each(locations, progress: 'Updating site_ids') do |location|
	site_exits = Site.find_by_site_name(location['name'])
	if site_exits.blank?
		#save to file for manual processing
        File.write('log/sites_not_found.log', "#{location['location_id'].to_i}" + ' ' + "#{location['name']} \n", mode: 'a')
	else
		site_exits.update(site_code: location['location_id'].to_i)
	end
end
