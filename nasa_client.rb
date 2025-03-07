require 'httparty'
require 'json'

class NasaClient
  include HTTParty

  base_uri 'https://api.nasa.gov/planetary/apod'

  def initialize(api_key:)
    @api_key = api_key
  end

  def get_image(date: nil, hd: false)
    query_params = {
      api_key: @api_key,
      hd: hd
    }

    query_params[:date] = date if date
    
    response = self.class.get('', query: query_params)

    if response.code == 200
      JSON.parse(response.body)
    else
      # Handle errors or unexpected responses
      { "error" => "Request failed with status #{response.code}: #{response.body}" }
    end
  end
end
