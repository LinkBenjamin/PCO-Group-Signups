module Pco
  require "net/http"
  require "uri"
  require "json"

  class PcoController < ApplicationController
    PCO_BASE_URL = "https://api.planningcenteronline.com"

    def people
      uri = URI("#{PcoController::PCO_BASE_URL}/people/v2/people")

      response = fetch_pco_data(uri)
      render json: response
    end

    def findperson
      name_or_email="link.ben"
      uri = URI("#{PcoController::PCO_BASE_URL}/people/v2/people?where[search_name_or_email]=#{name_or_email}")
      response = fetch_pco_data(uri)
      render json: response
    end

    private

    def fetch_pco_data(uri)
      app_id = Rails.application.credentials.dig(:pco, :app_id)
      app_secret = Rails.application.credentials.dig(:pco, :app_secret)

      return { error: "Missing PCO credentials" } unless app_id && app_secret

      req = Net::HTTP::Get.new(uri)
      req.basic_auth(app_id, app_secret)

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      JSON.parse(res.body) rescue { error: "Invalid response from PCO" }
    end
  end
end
