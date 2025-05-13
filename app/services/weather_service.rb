require 'open-weather-ruby-client'

class WeatherService
  def self.fetch(address)
    # Geocode the address to get latitude and longitude

    results = Geocoder.search(address)
    raise "Address not found" if results.empty?

    location = results.first
    zip = location.postal_code
    raise "Zip code not found for address" unless zip.present?

    # Set up OpenWeather client
    api_key = Rails.application.credentials.dig(:openweather, :api_key)
    raise "OpenWeather API key missing" unless api_key

    client = OpenWeather::Client.new(api_key: api_key)

    # Cache key based on zip code
    cache_key = "weather_#{zip}"

    # Check cache
    cached = Rails.cache.exist?(cache_key)
    weather_data = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      client.current_weather(zip: "#{zip},us", units: 'imperial')
    end

    {
      weather: weather_data,
      from_cache: cached,
      zip: zip
    }
  end
end
