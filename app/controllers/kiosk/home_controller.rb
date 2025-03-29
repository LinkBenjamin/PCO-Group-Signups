module Kiosk
  class Kiosk::HomeController < ApplicationController
    def index
      @message = "Don't freak out!" # This makes @message available in the view
      respond_to do |format|
        format.html # This looks for `app/views/kiosk/index.html.erb`
      end
    end
  end
end
