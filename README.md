# Introducing the MyWeatherForecast gem

    require 'myweatherforecast'

    forecast = MyWeatherForecast.new 55.91928883, -3.11704133, api_key: '465b3ad0268843820ac6076ea01cbff4'
    puts forecast.today
    #=> 11 degrees Celcius, Windy

Note: The API key provided here is a dummy key used for the examply only.

## Resources

* myweatherforecast https://rubygems.org/gems/myweatherforecast

myweatherforecast forecast_io gem wrapper

