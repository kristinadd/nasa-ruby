require 'ostruct' # graphql gem (version 1.13.22) internally uses OpenStruct
# OpenStruct used to be auto-loaded in older Ruby versions, but since Ruby 3.0+, it must be required manually.
require 'graphql/client'
require 'graphql/client/http'

# Set up the HTTP connection to the GraphQL API
module CountriesAPI
  HTTP = GraphQL::Client::HTTP.new("https://countries.trevorblades.com/")

  # Fetch the schema from the API (this is optional but gives you type checking)
  Schema = GraphQL::Client.load_schema(HTTP)

  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end

# Define your GraphQL query using heredoc
CountryQuery = CountriesAPI::Client.parse <<-'GRAPHQL'
  query($code: ID!) {
    country(code: $code) {
      name
      capital
      currency
      emoji
      languages {
        name
      }
    }
  }
GRAPHQL

# Call the query with a variable (e.g., "BR" for Brazil)
response = CountriesAPI::Client.query(CountryQuery, variables: { code: "BR" })

# Print the result
if response.data && response.data.country
  country = response.data.country
  puts "Country: #{country.name}"
  puts "Capital: #{country.capital}"
  puts "Currency: #{country.currency}"
  puts "Languages: #{country.languages.map(&:name).join(', ')}"
  puts "Emoji: #{country.emoji}"
else
  puts "Something went wrong!"
end
