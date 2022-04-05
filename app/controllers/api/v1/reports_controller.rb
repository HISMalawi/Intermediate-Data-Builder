class Api::V1::ReportsController < ApplicationController

  def cohort

  end

  def moh_desegregated(quarter,emr_type, region = 'ALL', district = 'ALL')
    if region == 'ALL' && district = 'ALL'
      report = MohDisagg.where('quarter = ? AND emr_type = ?', quarter,emr_type)
    else
      condition = ''
      condition += " AND region = '#{region}' " unless region.blank?
      condition += " AND district = '#{district}' " unless district.blank?
      #condition += " AND site_id = #{site_id} " unless site_id.blank?

      report = MohDisagg.where("quarter = '#{quarter}' AND emr_type = '#{emr_type}' #{condition}")
    end
    render json: report
  end

  def generate_report
    case report_params[:report_type]
    when 'moh_disagg'
      moh_desegregated(report_params[:quarter],
                       report_params[:emr_type],
                       report_params[:region],
                       report_params[:district])
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
      params.permit(:quarter,:emr_type, :report_type, :region, :district)
    end
end
