# Weather Forecaster

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
- OpenWeather API key (I have version-controlled the rails secrets file to simplify testing, however in production a secrets file should NEVER be version-controlled)

### Installation

1. Clone the repository: ```git clone https://github.com/yourusername/forecaster.git```

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