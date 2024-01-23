# frozen_string_literal: true
# Ensure that string literals in this file are frozen for performance and security.
# It prevents unintended modifications to the string literals.
# This is a good practice to include at the top of Ruby files.
# See: https://rubocop.readthedocs.io/en/latest/cops_style/#stylefrozen-string-literal

# Require the 'net/http' library to use it for making HTTP requests.
require 'net/http'

# Define a class named ExchangeRateApiService.
class ExchangeRateApiService
  # Define a class method 'get_exchange_rates' with an optional 'from' parameter defaulting to 'USD'.
  def self.get_exchange_rates(from = 'USD')
    # Create a URI object for the API endpoint, appending the 'from' parameter to the base URL.
    uri = URI("https://open.er-api.com/v6/latest/#{from}")

    # Use Net::HTTP to send an HTTP GET request to the specified URI.
    response = Net::HTTP.get_response(uri)

    # Check if the response is a successful HTTP response (2xx status code).
    # If not, return nil, indicating an unsuccessful request.
    return nil unless response.is_a?(Net::HTTPSuccess)

    # Parse the response body, assuming it contains JSON data.
    # Return the parsed JSON data.
    JSON.parse(response.body)
  end
end
