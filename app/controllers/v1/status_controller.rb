# frozen_string_literal: true

# app/controllers/v1/status_controller.rb
#
# Copyright 2020 TGW Consulting, LLC. All rights reserved.
#
# This source code is proprietary, confidential information of TGW Consulting, LLC.
# It contains TGW Consulting intellectual property, including trade secrets and
# copyright-protected authorship, and may include patentable inventions. You may
# not distribute this source code outside of TGW Consulting without express written
# permission from management. TGW Consulting does not claim ownership of included
# open source software components, which are subject to their own licenses.
#
require "date"
require Rails.root.join("config", "environment.rb")

module V1
  # /STATUS API route
  # Returns a detailed health status check on the API service.
  class StatusController < ApiController
    # GET /status
    # Returns detailed status report about the API service.
    def index
      current_time = DateTime.now.to_datetime
      render json: {
          service: service_name,
          version: service_version,
          rails_version: Rails::VERSION::STRING,
          ruby_version: RUBY_VERSION,
          database_connection: check_database,
          timestamp: current_time
      }, status: 200
    end

    private
    # Attempts to connect to the database defined in the config/environment and
    # returns an OK or ERROR status whether the connection is successful or not.
    def check_database
      begin
        ActiveRecord::Base.establish_connection
        ActiveRecord::Base.connection
        db_status = "OK" if ActiveRecord::Base.connected?
        db_status = "ERROR" unless ActiveRecord::Base.connected?
      end
      db_status
    end
  end
end
