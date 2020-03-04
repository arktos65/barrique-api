# frozen_string_literal: true

# app/controllers/v1/api_controller.rb
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

module V1
  # API controller that all other controllers will inherit from
  class ApiController < ::ApplicationController
    protected
    # Return the service name as a string
    def service_name
      "Barrique::API"
    end

    # Return the service version as a string
    def service_version
      "0.1.0"
    end
  end
end
