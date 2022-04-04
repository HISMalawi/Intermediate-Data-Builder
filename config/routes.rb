Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
 namespace :api do
  namespace :v1 do
    #Reporting end points
    get 'cohort', to: 'reports#cohort'
    get 'moh_desegregated', to: 'reports#moh_desegregated'
    get 'pepfar_desegregated', to: 'reports#pepfar_desegregated'
    get 'available_sites', to: 'reports#available_sites'
    get 'available_quarters', to: 'reports#available_quarters'
    get 'available_districts', to: 'reports#available_districts'
    get 'available_regions', to: 'reports#available_regions'
  end
 end
end
