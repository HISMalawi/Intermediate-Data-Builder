class Api::V1::ReportsController < ApplicationController

  AGE_GROUP_ORDERING = ['<1 year','1-4 years','5-9 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years',
                                               '40-44 years','45-49 years', '50-54 years', '55-59 years', '60-64 years', '65-69 years', '70-74 years', '75-79 years',
                                               '80-84 years', '85-89 years', '90 plus years', 'All']
  COLUMN_ORDER = MohDisagg.column_names[7..40]

  SCHEMA_MAPPING = {moh_disagg: 'MohDisagg', pepfar_disagg: 'PepfarDisagg'}

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
end
