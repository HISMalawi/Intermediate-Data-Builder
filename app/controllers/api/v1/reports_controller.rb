class Api::V1::ReportsController < ApplicationController

  AGE_GROUP_ORDERING = ['<1 year','1-4 years','5-9 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years',
                                               '40-44 years','45-49 years', '50-54 years', '55-59 years', '60-64 years', '65-69 years', '70-74 years', '75-79 years',
                                               '80-84 years', '85-89 years', '90 plus years', 'All']
  COLUMN_ORDER = MohDisagg.column_names[7..40]

  def cohort

  end

  def moh_desegregated(quarter, emr_type, region = report_params[:region], district = report_params[:district], site_id = report_params[:site_id])
    if region.blank? && district.blank? && site_id.blank?
      report = MohDisagg.find_by_sql("select
                     \"Age group\",
                    gender,
                    SUM(\"Tx new (new on ART)\") AS \"Tx new (new on ART)\",
                    SUM(\"TX curr (receiving ART)\") AS \"TX curr (receiving ART)\",
                    SUM(\"TX curr (received IPT)\") AS \"TX curr (received IPT)\",
                    SUM(\"TX curr (screened for TB)\") AS \"TX curr (screened for TB)\",
                    SUM(\"0A\") AS \"0A\",
                    SUM(\"2A\") AS \"2A\",
                    SUM(\"4A\") AS \"4A\",
                    SUM(\"5A\") AS \"5A\",
                    SUM(\"6A\") AS \"6A\",
                    SUM(\"7A\") AS \"7A\",
                    SUM(\"8A\") as \"8A\",
                    SUM(\"9A\") as \"9A\",
                    SUM(\"10A\") as \"10A\",
                    SUM(\"11A\") as \"11A\",
                    SUM(\"12A\") as \"12A\",
                    SUM(\"13A\") as \"13A\",
                    SUM(\"14A\") as \"14A\",
                    SUM(\"15A\") as \"15A\",
                    SUM(\"16A\") as \"16A\",
                    SUM(\"17A\") as \"17A\",
                    SUM(\"0P\") as \"0P\",
                    SUM(\"2P\") as \"2P\",
                    SUM(\"4P\") as \"4P\",
                    SUM(\"9P\") as \"9P\",
                    SUM(\"11P\") as \"11P\",
                    SUM(\"14P\") as \"14P\",
                    SUM(\"15P\") as \"15P\",
                    SUM(\"16P\") as \"16P\",
                    SUM(\"17P\") as \"17P\",
                    SUM(\"Unknown\") as \"Unknown\" ,
                    SUM(\"Total (regimen)\") as \"Total (regimen)\"
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
                    SUM(\"Tx new (new on ART)\") AS \"Tx new (new on ART)\",
                    SUM(\"TX curr (receiving ART)\") AS \"TX curr (receiving ART)\",
                    SUM(\"TX curr (received IPT)\") AS \"TX curr (received IPT)\",
                    SUM(\"TX curr (screened for TB)\") AS \"TX curr (screened for TB)\",
                    SUM(\"0A\") AS \"0A\",
                    SUM(\"2A\") AS \"2A\",
                    SUM(\"4A\") AS \"4A\",
                    SUM(\"5A\") AS \"5A\",
                    SUM(\"6A\") AS \"6A\",
                    SUM(\"7A\") AS \"7A\",
                    SUM(\"8A\") as \"8A\",
                    SUM(\"9A\") as \"9A\",
                    SUM(\"10A\") as \"10A\",
                    SUM(\"11A\") as \"11A\",
                    SUM(\"12A\") as \"12A\",
                    SUM(\"13A\") as \"13A\",
                    SUM(\"14A\") as \"14A\",
                    SUM(\"15A\") as \"15A\",
                    SUM(\"16A\") as \"16A\",
                    SUM(\"17A\") as \"17A\",
                    SUM(\"0P\") as \"0P\",
                    SUM(\"2P\") as \"2P\",
                    SUM(\"4P\") as \"4P\",
                    SUM(\"9P\") as \"9P\",
                    SUM(\"11P\") as \"11P\",
                    SUM(\"14P\") as \"14P\",
                    SUM(\"15P\") as \"15P\",
                    SUM(\"16P\") as \"16P\",
                    SUM(\"17P\") as \"17P\",
                    SUM(\"Unknown\") as \"Unknown\" ,
                    SUM(\"Total (regimen)\") as \"Total (regimen)\"
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
    end
  end


  def pepfar_desegregated
  end

  def available_sites
    render json: MohDisagg.distinct.select(:site_id, :site_name), status: :ok
  end

  def available_districts
    render json: MohDisagg.distinct.select(:district), status: :ok
  end

  def available_quarters
    render json: MohDisagg.distinct.select(:quarter), status: :ok
  end

  def available_regions
    render json: MohDisagg.distinct.select(:region), status: :ok
  end

  def available_emr_type
    render json: MohDisagg.distinct.select(:emr_type), status: :ok
  end

  private
    def report_params
      params.require([:quarter,:report_type, :emr_type])
      params.permit(:quarter,:emr_type, :report_type, :region, :district, :site_id)
    end
end
