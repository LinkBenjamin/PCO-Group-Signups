module Admin
  class Admin::DashboardController < ApplicationController
    def index
      render plain: "Admin Dashboard"
    end
  end
end
