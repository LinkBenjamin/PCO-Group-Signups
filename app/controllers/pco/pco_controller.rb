module Pco
  require "net/http"
  require "uri"
  require "json"
  require "base64"

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

    # Given a group ID, return the membership of the group.
    def  get_group_members
      groupid = params[:groupid].presence || "*"

      if groupid == "*"
        response = "ERROR - bad (or no) group id passed to get_group_members"
      else
        uri = URI("#{PcoController::PCO_BASE_URL}/groups/v2/groups/#{groupid}/memberships")
        response = fetch_pco_data(uri)
      end
      render json: response
    end

    # Given a person ID, return the person's object
    def get_person_by_id
      personid = params[:personid]

      uri = URI("#{PcoController::PCO_BASE_URL}/people/v2/people?where[id]=#{personid}")
      response = fetch_pco_data(uri)
      render json: response
    end

    # Given a person ID and a group ID, create a group membership record to add them
    def add_membership
      group_id = params[:group_id]
      person_id = params[:person_id]

      response = post_membership_to_planning_center(group_id, person_id)

      if response.code.to_i == 201
        render json: { message: "Member added successfully" }, status: :created
      else
        render json: { error: response.body }, status: :unprocessable_entity
      end
    end

    # Given a group ID and a person ID, remove any group membership records with these

    private

    def post_membership_to_planning_center(group_id, person_id)
      uri = URI.parse("https://api.planningcenteronline.com/groups/v2/groups/#{group_id}/memberships?include=#{person_id}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      app_id = Rails.application.credentials.dig(:pco, :app_id)
      app_secret = Rails.application.credentials.dig(:pco, :app_secret)

      request = Net::HTTP::Post.new(uri.request_uri)
      request["Authorization"] = "Basic " + Base64.strict_encode64("#{app_id}:#{app_secret}")
      request["Content-Type"] = "application/json"

      request.body = {
        data: {
          type: "Membership",
          relationships: {
            person: {
              data: {
                type: "Person",
                id: person_id
              }
            }
          }
        }
      }.to_json

      http.request(request)
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
