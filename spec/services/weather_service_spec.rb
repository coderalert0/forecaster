# spec/services/weather_service_spec.rb

require 'rails_helper'

RSpec.describe WeatherService do
  let(:address) { "1600 Amphitheatre Parkway, Mountain View, CA" }
  let(:zip) { "94043" }
  let(:lat) { 37.422 }
  let(:lon) { -122.084 }
  let(:api_key) { "fake_api_key" }
  let(:weather_response) do
    {
      "main" => {
        "temp" => 72.0,
        "temp_max" => 75.0,
        "temp_min" => 68.0,
        "humidity" => 50
      },
      "weather" => [
        { "description" => "clear sky" }
      ]
    }
  end

  before do
    allow(Rails.application).to receive_message_chain(:credentials, :dig).with(:openweather, :api_key).and_return(api_key)
    geocoder_result = double("GeocoderResult", postal_code: zip, latitude: lat, longitude: lon)
    allow(Geocoder).to receive(:search).with(address).and_return([geocoder_result])
    client_double = instance_double(OpenWeather::Client)
    allow(OpenWeather::Client).to receive(:new).with(api_key: api_key).and_return(client_double)
    allow(client_double).to receive(:current_weather).with(zip: "#{zip},us", units: 'imperial').and_return(weather_response)
    Rails.cache.clear
  end

  it "returns weather data for a valid address" do
    result = described_class.fetch(address)
    expect(result[:weather]).to eq(weather_response)
    expect(result[:zip]).to eq(zip)
    expect(result[:from_cache]).to eq(false)
  end

  it "caches the weather data by zip code" do
    memory_store = ActiveSupport::Cache.lookup_store(:memory_store)
    allow(Rails).to receive(:cache).and_return(memory_store)
    Rails.cache.clear

    described_class.fetch(address) # First call, populates cache
    result = described_class.fetch(address) # Second call, should hit cache
    expect(result[:from_cache]).to eq(true)
  end


  it "raises an error if address cannot be geocoded" do
    allow(Geocoder).to receive(:search).with(address).and_return([])
    expect { described_class.fetch(address) }.to raise_error("Address not found")
  end

  it "raises an error if API key is missing" do
    allow(Rails.application).to receive_message_chain(:credentials, :dig).with(:openweather, :api_key).and_return(nil)
    expect { described_class.fetch(address) }.to raise_error("OpenWeather API key missing")
  end

  it "raises an error if zip code is missing" do
    geocoder_result = double("GeocoderResult", postal_code: nil, latitude: lat, longitude: lon)
    allow(Geocoder).to receive(:search).with(address).and_return([geocoder_result])
    # Do NOT stub OpenWeather::Client for this test
    expect { described_class.fetch(address) }.to raise_error("Zip code not found for address")
  end
end
