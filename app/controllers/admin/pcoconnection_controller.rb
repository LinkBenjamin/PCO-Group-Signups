module Admin
  class Admin::PcoconnectionController < ApplicationController
    def index
      render plain: "Planning Center Online Connection Information"
    end
  end
end
