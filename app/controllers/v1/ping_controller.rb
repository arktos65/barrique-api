# frozen_string_literal: true

# app/controllers/v1/ping_controller.rb
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

module V1
  # /v1/ping route
  class PingController < ApiController
    # GET /v1/ping
    # Returns JSON formatted message and HTTP status code indicating service is responding.
    def index
      current_time = DateTime.now.to_datetime
      render json: {
          service: service_name,
          version: service_version,
          message: "Hello World",
          timestamp: current_time
      }, status: 200
    end
  end
end
