# What's new in the myweatherforecast gem version 0.4.0

    require 'myweatherforecast'

    w = MyWeatherForecast.new api_key: '465xxxxxxxxxxxxxx76ea01cbff4'
    puts w.days.take 3

output:

<pre>
Fri: 8° - 14°, Mostly cloudy throughout the day.
Sat: 6° - 13°, Light rain until afternoon.
Sun: 5° - 12°, Mostly cloudy throughout the day.
</pre>

---------------------

# What's new in the myweatherforecast gem version 0.3.3

    require 'myweatherforecast'

    w = MyWeatherForecast.new api_key: '465bxxxxxxxxx76ea01cbff4', timeout: 6

    puts w.now               #=> 10°C, Overcast
    puts w.saturday          #=> 12°C, Mostly Cloudy
    puts w.saturday.at '3pm' #=> 13°C, Mostly Cloudy

    puts w.monday 
    #=> min: 8° max: 12°, Mostly cloudy throughout the day.

    puts w.monday.at '3pm'
    #=> Monday outlook: 8° - 12°, Mostly cloudy throughout the day.

There's a couple of new features in this version. The location can now be retrieved automatically using your IP address from the geocoder gem. The forecast for any day of the week can now be retrieved.

Note: The IP address to GPS coordinates service used by the geocoder gem can lead to a timeout error when the service is apparently under heavy load.

-------------


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
