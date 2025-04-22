Rails.application.routes.draw do
  # Admin namespace
  namespace :admin do
    root to: "dashboard#index"
    get "pcoconnection", to: "pcoconnection#index"
    get "dashboard/index"
  end

  # Kiosk namespace
  namespace :kiosk do
    root to: "home#index"
    get "home/index"
  end

  # PCO namespace
  namespace :pco do
    get "people", to: "pco#findperson"
    get "groups", to: "pco#findgroup"
    get "groupmembers", to: "pco#get_group_members"
    get "person", to: "pco#get_person_by_id"
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
