class Api::V1::ReportsController < ApplicationController

   CONFIGURED_REPORTS = YAML.load_file("#{Rails.root}/config/application.yml")[:activated_reports]

  AGE_GROUP_ORDERING = ['<1 year','1-4 years','5-9 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years',
                                               '40-44 years','45-49 years', '50-54 years', '55-59 years', '60-64 years', '65-69 years', '70-74 years', '75-79 years',
                                               '80-84 years', '85-89 years', '90 plus years', 'All']
  COLUMN_ORDER = MohDisagg.column_names[7..40] rescue false

  SCHEMA_MAPPING = {moh_disagg: 'MohDisagg', pepfar_disagg: 'PepfarDisagg', 
                    eidsr_covid_19_triage: 'eidsr_covid', eidsr_registration_triage: 'eidsr_reg'}

  def cohort

  end

  def pepfar_disagregated(quarter,emr_type,region = report_params[:region], district = report_params[:district], site_id = report_params[:site_id])
    if region.blank? && district.blank? && site_id.blank?
      report = PepfarDisagg.find_by_sql("select
                     age_group,
                    gender,
                    SUM(\"Tx new (new on ART)\"::bigint) AS \"Tx new (new on ART)\",
                    SUM(\"Tx curr (receiving ART)\"::bigint) AS \"Tx curr (receiving ART)\",
                    SUM(\"Tx curr (received IPT)\"::bigint) AS \"Tx curr (received IPT)\",
                    SUM(\"Tx curr (screened for TB)\"::bigint) AS \"Tx curr (screened for TB)\"
                  from
                    quarterly_reporting.cohort_disaggregated_pepfar
                  where
                    quarter = '#{quarter}'
                  AND
                    emr_type = '#{emr_type}'
                  group by
                    age_group,
                    gender
                  ORDER BY gender;")
    else
      condition = ''
      condition += " AND region = '#{region}' " unless region.blank?
      condition += " AND district = '#{district}' " unless district.blank?
      condition += " AND site_id = #{site_id} " unless site_id.blank?
      condition['AND'] = 'WHERE ' unless condition.blank?

      report = PepfarDisagg.find_by_sql("select
                     age_group,
                    gender,
                    SUM(\"Tx new (new on ART)\"::bigint) AS \"Tx new (new on ART)\",
                    SUM(\"Tx curr (receiving ART)\"::bigint) AS \"Tx curr (receiving ART)\",
                    SUM(\"Tx curr (received IPT)\"::bigint) AS \"Tx curr (received IPT)\",
                    SUM(\"Tx curr (screened for TB)\"::bigint) AS \"Tx curr (screened for TB)\"
                  FROM
                    quarterly_reporting.cohort_disaggregated_pepfar
                  #{condition}
                  group by
                    age_group,
                    gender
                  ORDER BY gender;")
    end
    render json: format_pepfar_response(report)
  end

  def moh_desegregated(quarter, emr_type, region = report_params[:region], district = report_params[:district], site_id = report_params[:site_id])
    if region.blank? && district.blank? && site_id.blank?
      report = MohDisagg.find_by_sql("select
                     \"Age group\",
                    gender,
                    SUM(\"Tx new (new on ART)\"::bigint) AS \"Tx new (new on ART)\",
                    SUM(\"TX curr (receiving ART)\"::bigint) AS \"TX curr (receiving ART)\",
                    SUM(\"TX curr (received IPT)\"::bigint) AS \"TX curr (received IPT)\",
                    SUM(\"TX curr (screened for TB)\"::bigint) AS \"TX curr (screened for TB)\",
                    SUM(\"0A\"::bigint) AS \"0A\",
                    SUM(\"2A\"::bigint) AS \"2A\",
                    SUM(\"4A\"::bigint) AS \"4A\",
                    SUM(\"5A\"::bigint) AS \"5A\",
                    SUM(\"6A\"::bigint) AS \"6A\",
                    SUM(\"7A\"::bigint) AS \"7A\",
                    SUM(\"8A\"::bigint) as \"8A\",
                    SUM(\"9A\"::bigint) as \"9A\",
                    SUM(\"10A\"::bigint) as \"10A\",
                    SUM(\"11A\"::bigint) as \"11A\",
                    SUM(\"12A\"::bigint) as \"12A\",
                    SUM(\"13A\"::bigint) as \"13A\",
                    SUM(\"14A\"::bigint) as \"14A\",
                    SUM(\"15A\"::bigint) as \"15A\",
                    SUM(\"16A\"::bigint) as \"16A\",
                    SUM(\"17A\"::bigint) as \"17A\",
                    SUM(\"0P\"::bigint) as \"0P\",
                    SUM(\"2P\"::bigint) as \"2P\",
                    SUM(\"4P\"::bigint) as \"4P\",
                    SUM(\"9P\"::bigint) as \"9P\",
                    SUM(\"11P\"::bigint) as \"11P\",
                    SUM(\"14P\"::bigint) as \"14P\",
                    SUM(\"15P\"::bigint) as \"15P\",
                    SUM(\"16P\"::bigint) as \"16P\",
                    SUM(\"17P\"::bigint) as \"17P\",
                    SUM(\"Unknown\"::bigint) as \"Unknown\" ,
                    SUM(\"Total (regimen)\"::bigint) as \"Total (regimen)\"
                  from
                    quarterly_reporting.cohort_disaggregated_moh
                  where
                    quarter = '#{quarter}'
                  AND
                    emr_type = '#{emr_type}'
                  group by
                    \"Age group\",
                    gender
                  ORDER BY gender;")
    else
      condition = ''
      condition += " AND region = '#{region}' " unless region.blank?
      condition += " AND district = '#{district}' " unless district.blank?
      condition += " AND site_id = #{site_id} " unless site_id.blank?
      condition['AND'] = 'WHERE ' unless condition.blank?

      report = MohDisagg.find_by_sql("select
                     \"Age group\",
                    gender,
                    SUM(\"Tx new (new on ART)\"::bigint) AS \"Tx new (new on ART)\",
                    SUM(\"TX curr (receiving ART)\"::bigint) AS \"TX curr (receiving ART)\",
                    SUM(\"TX curr (received IPT)\"::bigint) AS \"TX curr (received IPT)\",
                    SUM(\"TX curr (screened for TB)\"::bigint) AS \"TX curr (screened for TB)\",
                    SUM(\"0A\"::bigint) AS \"0A\",
                    SUM(\"2A\"::bigint) AS \"2A\",
                    SUM(\"4A\"::bigint) AS \"4A\",
                    SUM(\"5A\"::bigint) AS \"5A\",
                    SUM(\"6A\"::bigint) AS \"6A\",
                    SUM(\"7A\"::bigint) AS \"7A\",
                    SUM(\"8A\"::bigint) as \"8A\",
                    SUM(\"9A\"::bigint) as \"9A\",
                    SUM(\"10A\"::bigint) as \"10A\",
                    SUM(\"11A\"::bigint) as \"11A\",
                    SUM(\"12A\"::bigint) as \"12A\",
                    SUM(\"13A\"::bigint) as \"13A\",
                    SUM(\"14A\"::bigint) as \"14A\",
                    SUM(\"15A\"::bigint) as \"15A\",
                    SUM(\"16A\"::bigint) as \"16A\",
                    SUM(\"17A\"::bigint) as \"17A\",
                    SUM(\"0P\"::bigint) as \"0P\",
                    SUM(\"2P\"::bigint) as \"2P\",
                    SUM(\"4P\"::bigint) as \"4P\",
                    SUM(\"9P\"::bigint) as \"9P\",
                    SUM(\"11P\"::bigint) as \"11P\",
                    SUM(\"14P\"::bigint) as \"14P\",
                    SUM(\"15P\"::bigint) as \"15P\",
                    SUM(\"16P\"::bigint) as \"16P\",
                    SUM(\"17P\"::bigint) as \"17P\",
                    SUM(\"Unknown\"::bigint) as \"Unknown\" ,
                    SUM(\"Total (regimen)\"::bigint) as \"Total (regimen)\"
                  FROM
                    quarterly_reporting.cohort_disaggregated_moh
                  #{condition}
                  group by
                    \"Age group\",
                    gender
                  ORDER BY gender;")
    end
    render json: format_response(report)
  end

  def format_pepfar_response(records)
    data = []
    gender_ordering = ['Female', 'Male', 'FP', 'FNP', 'FBf']
     gender_ordering.each do |gender|
      AGE_GROUP_ORDERING.each do |group|
        records.each do |row|
           data << row if row['age_group'] == group && row['gender'] == gender
        end
      end
     end
    return data
  end

  def format_response(records)
    data = []
    gender_ordering = ['Female', 'Male', 'FP', 'FNP', 'FBf']
     gender_ordering.each do |gender|
      AGE_GROUP_ORDERING.each do |group|
        records.each do |row|
          reordered = {}
          COLUMN_ORDER.each do |column|
           reordered[column] = row[column]
          end
           data << reordered if row['Age group'] == group && row['gender'] == gender
        end
      end
     end
    return data
  end

  def generate_report
    case report_params[:report_type]
    when 'moh_disagg'
      moh_desegregated(report_params[:quarter],
                       report_params[:emr_type]
                       )
    when 'pepfar_disagg'
      pepfar_disagregated(report_params[:quarter],
                          report_params[:emr_type]  
      )  
    end
  end

  def available_sites
    render json: available.classify.constantize.where(district: site_params[:district]).distinct.select(:site_id, :site_name), status: :ok
  end

  def available_districts
    render json: available.classify.constantize.where(region: district_params[:region]).distinct.select(:district), status: :ok
  end

  def available_quarters
    render json: available.classify.constantize.distinct.select(:quarter), status: :ok
  end

  def available_regions
    render json: available.classify.constantize.distinct.select(:region), status: :ok
  end

  def available_emr_type
    render json: available.classify.constantize.distinct.select(:emr_type), status: :ok
  end

  def available_reports
    render json: available_rpts, status: :ok
  end

  def pull_report
    begin
      report = pull_report_params
      condition = generate_conditions
      render json: ActiveRecord::Base.connection.select_all("SELECT * FROM #{report[:report]} #{condition}"), status: :ok
    rescue => e
      render json: e, status: :internal_server_error
    end
  end

  def eidsr_registration_triage
    condition = generate_conditions
    data = ActiveRecord::Base.connection.select_all("select age_groups.case as age_group,
      SUM(case when lower(age_groups.gender) = 'm' then 1 end) as \"male\",
      SUM(case when lower(age_groups.gender) = 'f' then 1 end) as \"female\",
      count(*) as \"total\" 
      from (select gender, case 
                  when age <= 0 then '<1-year'
                  when age between 1 and 4 then '1-4 years'
                  when age between 5 and 9 then '5-9 years'
                  when age between 10 and 14 then '10-14 years'
                  when age between 15 and 19 then '15-19 years'
                  when age between 20 and 24 then '20-24 years'
                  when age between 25 and 29 then '25-29 years'
                  when age between 30 and 34 then '30-34 years'
                  when age between 35 and 39 then '35-39 years'
                  when age between 40 and 44 then '40-44 years'
                  when age between 45 and 49 then '45-49 years'
                  when age between 50 and 54 then '50-54 years'
                  when age between 55 and 59 then '55-59 years'
                  when age between 60 and 64 then '60-64 years'
                  when age between 65 and 69 then '65-69 years'
                  when age between 70 and 74 then '70-74 years'
                  when age between 75 and 79 then '75-79 years'
                  when age between 80 and 84 then '80-84 years'
                  when age between 85 and 89 then '85-89 years'
                  when age >90 then '90 plus years' 
                  end
                from quarterly_reporting.eidsr_reports er #{condition}) as age_groups
                group by age_groups.case, age_groups.gender;")
    formated_data = []
    data.each do |row|
      formated_data << {age_group: row['age_group'],
                        male: row['male'] || 0,
                        female: row['female'] || 0,
                        total: row['total'] || 0
                      }
    end

   render json: formated_data, status: :ok
  end

  def eidsr_covid_19_triage
    condition = generate_conditions
    data = ActiveRecord::Base.connection.select_all("select conditions as condition, 
      SUM(case when lower(er.gender) = 'm' then 1 end) \"male\",
      SUM(case when lower(er.gender) = 'f' then 1 end) \"female\",
      count(*) \"total\"
      from quarterly_reporting.eidsr_reports er #{condition}
      group by er.conditions;")
    
    formated_data = []
    data.each do |row|
      formated_data << {condition: row['condition'],
                        male: row['male'] || 0,
                        female: row['female'] || 0,
                        total: row['total'] || 0
                      }
    end
   render json: formated_data, status: :ok
  end


  private
    def report_params
      params.require([:quarter,:report_type, :emr_type])
      params.permit(:quarter,:emr_type, :report_type, :region, :district, :site_id)
    end

    def district_params
      params.require(:region)
      params.permit(:region)
    end

    def site_params
      params.require(:district)
      params.permit(:district)
    end

    def available
      params.require(:report_type)
      params.permit(:report_type)
      case params[:report_type]
      when 'moh_disagg'
       return 'MohDisagg'
      when 'pepfar_disagg'
       return 'PepfarDisagg'
      end
    end

    def pull_report_params
      params.require(:report)
      params.permit!
    end

    def available_rpts
      
      reports = {}
      Parallel.each(ActiveRecord::Base.connection.tables, in_threads: Etc.nprocessors.to_i) do | table |
          next unless CONFIGURED_REPORTS.include?(table)
          reports[table] = {}
        ActiveRecord::Base.connection.columns(table).map(&:name).each do | field |
          reports[table][field] =  ActiveRecord::Base.connection.select_all("select distinct #{field} from #{table}").map(&:values).flatten
        end
      end
      reports
    end

    def generate_conditions
      condition = ''
      params.each do | value |
        next if value[0] == 'controller' || value[0] == 'action' || value[0] == 'report'
        condition += condition.blank? ? "WHERE #{value[0]} = '#{value[1]}' " : " AND #{value[0]} = '#{value[1]}'"
      end
      return condition
    end
end
