# Forecaster

<img width="609" alt="Screenshot 2025-05-13 at 3 15 37 PM" src="https://github.com/user-attachments/assets/0ebee3e2-a0ea-452f-ab28-f2f275dec365" />

A Ruby on Rails application that provides current weather information based on user-entered addresses.  
The app uses the OpenWeather API to fetch weather data and caches results by zip code for improved performance.

---

## Features

- Geocodes user addresses to extract zip codes.
- Fetches current weather data from OpenWeather API using zip code.
- Caches weather data for 30 minutes per zip code to minimize API calls.
- Handles errors gracefully (invalid addresses, missing API keys, unsupported zip codes).
- Simple and user-friendly web interface.

---

## Getting Started

### Prerequisites

- Ruby 3.3.0 (or compatible version)
- Rails 7.x
- OpenWeather API key (I have version-controlled config/master.key to simplify testing, however in production config/master.key should NEVER be version-controlled)

### Installation

1. Clone the repository: ```git clone https://github.com/coderalert0/forecaster```

2. Change directory: ```cd forecaster```

3. Install dependencies: ```bundle install```

4. Enable caching in development environment: ```rails dev:cache```
   
5. Run the Rails server: ```rails server```

6. Open your browser and visit: ```http://localhost:3000```


---

## Usage

- Enter a valid address in the form.
- Submit to view the current weather forecast for the address’s zip code.
- Weather data is cached for 30 minutes per zip code to reduce API calls.

---

## Testing

This app uses RSpec for unit testing.

To run tests: ```bundle exec rspec```

---

## Classes Implemented

1. app/services/weather_service.rb

2. app/controllers/forecasts_controller.rb

3. app/views/forecasts/show.html.erb

4. spec/services/weather_service_spec.rb

5. app/controllers/forecasts_controller_spec.rb

---
