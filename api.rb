require "sinatra"
require "json"
require "mongo"
require "dotenv/load"
require "deep_merge"

client = Mongo::Client.new(ENV['MONGODB_URI']);
db = client.database
@@collection = client[:sattelites]

get "/api/ping" do
  return {message: "pong"}.to_json
end

put "/api/satellite" do
  halt 400, {message: 'Bad request' }.to_json if !params || !params[:file] || !params[:file][:tempfile]
  halt 400, {message: 'Bad data'}.to_json if params[:file][:type] != "text/json"
  json_data = JSON.parse(params[:file][:tempfile].read)
  return {message: "Satellite updated"}.to_json
end

get "*" do
  status 404
  return {message: "Not found"}.to_json
end

def get_sattelite(id)
  return @@collection.find( { satellite_id: id } ).first
end

def insert_sattelite(data)
  return @@collection.insert_one(data)
end

def update_sattelite(id, data)
  return @@collection.update_one( { satellite_id: id }, data )
end

def merge_data(doc, data)
  return doc.deep_merge!(data, {:overwrite_arrays => true})
end
