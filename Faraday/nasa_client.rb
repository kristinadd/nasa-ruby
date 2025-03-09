require 'faraday'
require 'json'

class NasaClient
  BASE_URL = 'https://api.nasa.gov/planetary/apod'

  def initialize(api_key:)
    @api_key = api_key
    @conn = Faraday.new(url: BASE_URL) do |faraday|
      faraday.adapter Faraday.default_adapter       # Use the default adapter (Net::HTTP)
    end
  end

  def get_image(date: nil, hd: false)
    query_params = {
      'api_key' => @api_key,
      'hd' => hd
    }
    query_params['date'] = date if date

    response = @conn.get do |req|
      req.params = query_params
    end

    if response.success?
      JSON.parse(response.body)
    else
      { "error" => "Request failed with status #{response.status}: #{response.body}" }
    end
  end
end

# Example usage:
if __FILE__ == $0
  client = NasaClient.new(api_key: 'API_KEY')
  today_image = client.get_image
  puts "Today's APOD:\n#{today_image}\n\n"

  dated_image = client.get_image(date: '2012-07-07', hd: true)
  puts "APOD for 2012-07-07:\n#{dated_image}\n\n"
end
