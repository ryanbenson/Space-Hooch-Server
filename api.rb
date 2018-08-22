require "sinatra"
require "json"

get "/api/ping" do
  return {message: "pong"}.to_json
end

put "/api/satellite" do
  return {message: "Satellite updated"}.to_json
end

get "*" do
  status 404
  return {message: "Not found"}.to_json
end
