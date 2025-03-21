require 'webrick'
require 'json'
require 'graphql'
require 'faraday'

# ====== REST Client (NASA API) ======
class NasaClient
  BASE_URL = 'https://api.nasa.gov/planetary/apod'

  def initialize(api_key:)
    @api_key = api_key
    @conn = Faraday.new(url: BASE_URL)
  end

  def get_apod(date: nil, hd: false)
    params = { 'api_key' => @api_key, 'hd' => hd }
    params['date'] = date if date
    response = @conn.get('', params)

    response.success? ? JSON.parse(response.body) : nil
  end
end

# ====== GraphQL Schema ======
class ApodType < GraphQL::Schema::Object
  field :title, String, null: true
  field :url, String, null: true
  field :explanation, String, null: true
  field :date, String, null: true
end

class QueryType < GraphQL::Schema::Object
  field :apod, ApodType, null: true do
    argument :date, String, required: false
    argument :hd, Boolean, required: false
  end

  def apod(date: nil, hd: false)
    nasa = NasaClient.new(api_key: ENV['NASA_API_KEY'] || 'DEMO_KEY')
    nasa.get_apod(date: date, hd: hd)
  end
end

class NasaSchema < GraphQL::Schema
  query(QueryType)
end

# ====== Basic HTTP Server using WEBrick ======
server = WEBrick::HTTPServer.new(Port: 4567)

# Serve GraphQL POST requests
server.mount_proc '/graphql' do |req, res|
  if req.request_method == 'POST'
    request_payload = JSON.parse(req.body)
    result = NasaSchema.execute(
      request_payload["query"],
      variables: request_payload["variables"]
    )

    res.status = 200
    res['Content-Type'] = 'application/json'
    res.body = result.to_json
  else
    res.status = 405
    res.body = 'Only POST supported at /graphql'
  end
end

# Graceful shutdown with Ctrl+C
trap('INT') { server.shutdown }

puts "GraphQL server running at http://localhost:4567/graphql"
server.start
