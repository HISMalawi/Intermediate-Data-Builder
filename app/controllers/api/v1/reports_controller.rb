class Api::V1::ReportsController < ApplicationController

  def cohort

  end

  def moh_desegregated

  end


  def pepfar_desegregated
  end

  def available_sites
  end

  def available_districts
  end

  def available_quarters
  end

  def available_regions
  end

  private
    def report_params
      params.require(:quarter)
      params.permit(:report_type, coverage: [])
    end
end
