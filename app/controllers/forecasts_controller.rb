class ForecastsController < ApplicationController
  def show
    @address = params[:address]
    @result = nil
    @error = nil

    if params[:address].present?
      begin
        @result = WeatherService.fetch(@address)
      rescue => e
        @error = e.message
      end
    end
  end
end
