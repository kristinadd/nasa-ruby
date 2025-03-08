require_relative 'nasa_client'
require 'httparty'
class Test
  # if __FILE__ == $0
  #   client = NasaClient.new(api_key: 'KEY')
  
  #   today_image = client.get_image
  #   puts "Today's APOD:\n#{today_image}\n\n"

  #   dated_image = client.get_image(date: '2012-07-07', hd: true)
  #   puts "APOD for 2023-03-01:\n#{dated_image}\n\n"
  # end

  require 'httparty'

  response = HTTParty.get(
    'https://api.nasa.gov/planetary/apod',
    query: {
      api_key: 'KEY',
      count: 7,
      hd: true
    }
  )

  puts response.body

end
