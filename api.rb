require "sinatra"
require "json"
require "mongo"
require "dotenv/load"
require "deep_merge"

client = Mongo::Client.new(ENV['MONGODB_URI']);
db = client.database
collection = client[:sattelites]

before do
  content_type 'application/json'
end

get "/api/ping" do
  return {message: "pong"}.to_json
end

get "/api/satellites" do
  return get_all(collection).to_json
end

put "/api/satellites" do
  halt 400, {message: 'Bad request' }.to_json if !params || !params[:file] || !params[:file][:tempfile]
  halt 400, {message: 'Bad data'}.to_json if !['text/json', 'application/json'].include? params[:file][:type]
  json_data = JSON.parse(params[:file][:tempfile].read)
  satellite_id = json_data["satellite_id"]
  satellite = get_sattelite(collection, satellite_id)

  if satellite.nil?
    insert_sattelite(collection, json_data)
    return {message: "Satellite added"}.to_json
  else
    merged_data = merge_data(satellite, json_data)
    update_sattelite(collection, satellite_id, merged_data)
    return {message: "Satellite updated"}.to_json
  end
end

get "*" do
  status 404
  return {message: "Not found"}.to_json
end

def get_all(coll)
  list = []
  coll.find.each do |doc|
    list << doc
  end
  return list
end

def get_sattelite(coll, id)
  return coll.find( { satellite_id: id } ).first
end

def insert_sattelite(coll, data)
  return coll.insert_one(data)
end

def update_sattelite(coll, id, data)
  return coll.update_one( { satellite_id: id }, data )
end

def merge_data(doc, data)
  return doc.deep_merge!(data, {:overwrite_arrays => true})
end
