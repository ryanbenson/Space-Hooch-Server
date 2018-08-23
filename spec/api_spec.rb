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

  before(:all) do
    client = Mongo::Client.new(ENV['MONGODB_URI']);
    db = client.database
    collection = client[:sattelites]
    collection.delete_many({})
  end

  context "when managing data" do
    it "should be able to create a sattelite" do
      satellite_data_file = File.join(Dir.pwd, "spec", "sattelite.json")
      file = File.read(satellite_data_file)
      data = JSON.parse(file)

      inserted = insert_sattelite(data)
      expect(inserted.n).to eql 1
    end

    it "should be able to find a document" do
      data = get_sattelite(1)
      expect(data["satellite_id"]).to eql 1
    end

    it "should update a record" do
      satellite_data_file = File.join(Dir.pwd, "spec", "sattelite_update.json")
      file = File.read(satellite_data_file)
      data = JSON.parse(file)

      updated = update_sattelite(data["satellite_id"], data)
      p updated
      expect(updated.modified_count).to eql 1
    end
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

  context "when needing to merge data" do
    it "should merge two deep hashes together" do
      original = {:x => [1,2,3], :y => 2, :z => "hello"}
      updated =   {:x => [4,5,6], :y => [7,8,9], :a => ["1", [true]]}
      merged_hash = merge_data(original, updated)
      expected = {:a=>["1", [true]], :x => [4,5,6], :y => [7,8,9], :z => "hello"}
      expect(merged_hash).to eql expected
    end
  end
end
