# What's new in the myweatherforecast gem version 0.3.1

    require 'myweatherforecast'

    mwf = MyWeatherForecast.new 'Lochend, Edinburgh', api_key: '465xxxxxxxxxxxx6ea01cbff4'


    puts mwf.tomorrow #=> 9°C, Mostly Cloudy
    mwf.tomorrow.time #=> 2015-10-24 12:00:00 +0100
    mwf.tomorrow.icon #=> "partly-cloudy-day"
    mwf.tomorrow.windspeed #=> 16
    puts mwf.tomorrow.temperature #=> 9°

    puts mwf.tomorrow.at('3pm') #=> 9°C, Mostly Cloudy

    mwf.tomorrow.at('3pm').time #=> 2015-10-24 15:00:00 +0100
    puts mwf.tomorrow.at('6pm').temperature #=> 8°
    puts mwf.today #=> 9°C, Overcast
    puts mwf.today.at '10am' #=> 10°C, Mostly Cloudy


As you can see, the location no longer has to be GPS coordinates.

## Resources

* myweatherforecast https://rubygems.org/gems/myweatherforecast

myweatherforecast forecast_io
