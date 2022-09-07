Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
 namespace :api do
  namespace :v1 do
    #Reporting end points
    get 'generate_report', to: 'reports#generate_report'
    get 'available_sites', to: 'reports#available_sites'
    get 'available_quarters', to: 'reports#available_quarters'
    get 'available_districts', to: 'reports#available_districts'
    get 'available_regions', to: 'reports#available_regions'
    get 'available_emr_type', to: 'reports#available_emr_type'
    get 'available_reports', to: 'reports#available_reports'
    get 'pull_report', to: 'reports#pull_report'
  end
 end
end
