require 'rails_helper'

RSpec.describe ForecastsController, type: :controller do
  describe "GET #show" do
    let(:address) { "1600 Amphitheatre Parkway, Mountain View, CA" }
    let(:zip) { "94043" }
    let(:weather_result) do
      {
        weather: {
          "main" => {
            "temp" => 72.0,
            "temp_max" => 75.0,
            "temp_min" => 68.0,
            "humidity" => 50
          },
          "weather" => [
            { "description" => "clear sky" }
          ]
        },
        from_cache: false,
        zip: zip
      }
    end

    context "when no address is provided" do
      it "renders the show template with no result or error" do
        get :show
        expect(response).to render_template(:show)
        expect(assigns(:address)).to be_nil
        expect(assigns(:result)).to be_nil
        expect(assigns(:error)).to be_nil
      end
    end

    context "when a valid address is provided" do
      before do
        allow(WeatherService).to receive(:fetch).with(address).and_return(weather_result)
      end

      it "assigns the result and renders the show template" do
        get :show, params: { address: address }
        expect(response).to render_template(:show)
        expect(assigns(:address)).to eq(address)
        expect(assigns(:result)).to eq(weather_result)
        expect(assigns(:error)).to be_nil
      end
    end

    context "when WeatherService raises an error" do
      before do
        allow(WeatherService).to receive(:fetch).with(address).and_raise("Address not found")
      end

      it "assigns the error and renders the show template" do
        get :show, params: { address: address }
        expect(response).to render_template(:show)
        expect(assigns(:address)).to eq(address)
        expect(assigns(:result)).to be_nil
        expect(assigns(:error)).to eq("Address not found")
      end
    end
  end
end
