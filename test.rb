require_relative 'nasa_client'
class Test
  if __FILE__ == $0
    client = NasaClient.new(api_key: 'NASA_API_KEY')
  
    today_image = client.get_image
    puts "Today's APOD:\n#{today_image}\n\n"
  
    dated_image = client.get_image(date: '2023-03-01', hd: true)
    puts "APOD for 2023-03-01:\n#{dated_image}\n\n"
  end
end
