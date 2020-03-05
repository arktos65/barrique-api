# frozen_string_literal: true

# spec/requests/v1/status_spec.rb
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
require "rails_helper"

RSpec.describe "Status API", type: :request do
  describe "GET /v1/status" do
    before { get "/v1/status" }

    it "should return a valid service name" do
      expect(json["service"]).to eq("Barrique::API")
    end

    it "should return an OK database connection" do
      expect(json["database_connection"]).to eq("OK")
    end

    it "returns a valid status code" do
      expect(response).to have_http_status(200)
    end
  end
end
