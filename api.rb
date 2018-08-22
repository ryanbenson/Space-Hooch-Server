require "sinatra"
require "json"

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
