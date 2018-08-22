ENV['RACK_ENV'] = "test"

require_relative "../api"
require "rspec"
require "rack/test"
require "json"

describe "Api" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context "when accessing the Api server" do
    it "should not have a home page" do
      get "/"
      expect(last_response.status).to eql 404
      expect(JSON.parse(last_response.body)["message"]).to eq("Not found")
    end

    it "should return a pong when pinged" do
      get "/api/ping"
      expect(last_response.status).to eql 200
      expect(JSON.parse(last_response.body)["message"]).to eq("pong")
    end

    it "should update a satellite when posting a JSON file" do
      put "/api/satellite"
      expect(last_response.status).to eql 200
      expect(JSON.parse(last_response.body)["message"]).to eq("Satellite updated")
    end

  end
end
