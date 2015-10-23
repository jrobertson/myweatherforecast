#!/usr/bin/env ruby

# file: myweatherforecast.rb

require 'time'
require 'geocoder'
require 'forecast_io'



# This gem is a wrapper of the forecast_io gem
# SI explained: https://en.wikipedia.org/wiki/SI_derived_unit

class MyWeatherForecast

  def initialize(*location, api_key: nil, units: :auto)
    
    lat, lon = if location.length > 1 then
    
      location
      
    else
      
      results = Geocoder.search(location.first)
      return puts 'location not found' unless results.any?
      results[0].coordinates
      
    end

    ForecastIO.api_key = api_key

    params = { units: units.to_s }
    @forecast = ForecastIO.forecast(lat, lon, params: params)

    autounits = @forecast['flags']['units']
    
    @tlabel = autounits == 'us' ? '°F' : '°C'      
    
  end

  class Day

    def initialize(forecast, tlabel, i=nil)
      
      @forecast = forecast
      @x = i ? forecast['hourly']['data'][i] : forecast.currently
      @tlabel = tlabel

    end    
    
    def at(raw_hour)
      
      hour = Time.parse(raw_hour).hour
      i = 0
      i += 1 until Time.at(@forecast['hourly']['data'][i]['time']).hour \
                                                                  ==  hour.to_i
      Day.new(@forecast, @tlabel, i)
    end
    
    def humidity()
      @x.humidity
    end
    
    def icon()
      @x.icon
    end

    def to_s
      "%d%s, %s" % [@x.temperature.round, @tlabel, @x.summary]
    end

    def summary()
      @x.summary
    end
    
    def temperature
      "%s°" % @x.temperature.round
    end
    
    def time
      Time.at @x.time
    end

    def visibility()
      @x.visibility
    end
    
    def windspeed()
      @x.windSpeed.round
    end
    
  end
  
  class DaysAhead < Day
    
    def initialize(forecast, tlabel, index: 0)
      
      @forecast = forecast
      @x = forecast['hourly']['data'][index]      
      @tlabel = tlabel
      @i = index
      
    end
    
    def at(raw_hour)
      
      hour = Time.parse(raw_hour).hour

      i = @i - 12
      i += 1 until Time.at(@forecast['hourly']['data'][i]['time']).hour \
                                                                  ==  hour.to_i
      DaysAhead.new(@forecast, @tlabel, index: i)
    end    

  end

  def today()
    Day.new(@forecast, @tlabel)
  end

  def tomorrow()
    
    # select tomorrow at midday
    i = 0
    
    i += 7 if Time.at(@forecast['hourly']['data'][i]['time']).hour >= 6
    
    i += 1 until Time.at(@forecast['hourly']['data'][i]['time']).hour ==  12
    DaysAhead.new(@forecast, @tlabel, index: i)
  end

end
