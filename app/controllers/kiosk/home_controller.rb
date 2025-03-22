module Kiosk
  class Kiosk::HomeController < ApplicationController
    def index
      render plain: "Welcome to the group signup kiosk"
    end
  end
end
