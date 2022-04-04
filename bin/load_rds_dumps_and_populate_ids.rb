def main
  rds_db = YAML.load_file("#{Rails.root}/config/database.yml")['rds']

  puts 'Please enter path to RDS dumps location: default ~/dumps/not_loaded/'
  rds_dump_path = gets.chomp

  rds_dump_path =  '~/dumps/not_loaded/*.sql' if rds_dump_path.blank?

  rds_dump_files = `ls -Sr #{rds_dump_path}`.split("\n")

  rds_dump_files.each do | file |
    sql_commands = []
    File.read(file).each_line do | cmd |
      sql_commands << cmd
    end
    Parallel.each(sql_commands, progress: "Loading #{file} to rds", in_threads: 60) do | sql_command |
      `mysql -u#{rds_db['username']} -p#{rds_db['password']} #{rds_db['database']} < #{sql_command}`
    end
    `cd /opt/pentaho`
    `export KETTLE_HOME=/opt/pentaho/`
    `./CDWRun.sh`
    `mv #{file} ~/dumps/loaded/`
  end
 end

main