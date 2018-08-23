require "dotenv"
Dotenv.load('.test.env')

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

    it "should fail to update satellite with no file provided" do
      put "/api/satellite"
      expect(last_response.status).to eql 400
      expect(JSON.parse(last_response.body)["message"]).to eql("Bad request")
    end

    it "should fail to update a satellite if file is not text/json" do
      satellite_data_file_bad = File.join(Dir.pwd, "spec", "sattelite.txt")
      put "/api/satellite", "file" => Rack::Test::UploadedFile.new(satellite_data_file_bad, "text/plain")
      expect(last_response.status).to eql 400
      expect(JSON.parse(last_response.body)["message"]).to eq("Bad data")
    end

    it "should update a satellite when posting a JSON file" do
      satellite_data_file = File.join(Dir.pwd, "spec", "sattelite.json")
      put "/api/satellite", "file" => Rack::Test::UploadedFile.new(satellite_data_file, "text/json")
      expect(last_response.status).to eql 200
      expect(JSON.parse(last_response.body)["message"]).to eq("Satellite updated")
    end

  end
end
