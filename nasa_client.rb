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

    # this adds the date parameter to the query_params hash if a date is provided
    # all modify the hash 'in place'
    query_params[:date] = date if date # modifies in place and returns the assigned value
    query_params.store(:date, date) if date # modifies in place and assigned value
    query_params.merge!(date: date) if date # modifies in place and returns the modified hash
    query_params.update(date: date) if date # modifies in place and returns the modified hash


    
    response = self.class.get('', query: query_params)

    if response.code == 200
      JSON.parse(response.body)
    else
      { "error" => "Request failed with status #{response.code}: #{response.body}" }
    end
  end
end
