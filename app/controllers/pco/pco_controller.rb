module Pco
  require "net/http"
  require "uri"
  require "json"

  class PcoController < ApplicationController
    PCO_BASE_URL = "https://api.planningcenteronline.com"

    # Find a person in PCO based on our search string.
    # This endpoint accepts one parameter, called "search_string".
    # If the search_string is 10 characters and all numeric, it's searched against the phone number field.
    # If the search_string is anything else, it's searched against the name or email address.
    def findperson
      search_string = params[:search_string] # Retrieves the parameter 'search_string'

      uri = URI("#{PcoController::PCO_BASE_URL}/people/v2/people?where[search_name_or_email_or_phone_number]=#{search_string}")

      response = fetch_pco_data(uri)
      render json: response
    end

    # Find a group in PCO based on our search string.
    # This endpoint accepts one optional parameter, called "search_string".
    # The search_string is used to filter groups by name.
    # If search_string isn't provided, we use * to connote that we want to return ALL groups.
    def findgroup
      search_string = params[:search_string].presence || "*" # Retrieves the parameter 'search_string'

      if search_string == "*"
        uri = URI("#{PcoController::PCO_BASE_URL}/groups/v2/groups")
      else
        uri = URI("#{PcoController::PCO_BASE_URL}/groups/v2/groups?where[name]=#{search_string}")
      end

      response = fetch_pco_data(uri)
      render json: response
    end

    private

    def is_number(val)
      true if Float(val) rescue false
    end

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
