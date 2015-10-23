#!/usr/bin/env ruby

# file: myweatherforecast.rb

require 'forecast_io'
require 'time'

# This gem is a wrapper of the forecast_io gem
# SI explained: https://en.wikipedia.org/wiki/SI_derived_unit

class MyWeatherForecast

  def initialize(lat, lon, api_key: nil, si: true)

    ForecastIO.api_key = api_key
  

    if si then
      params = { units: 'si' }
      @tlabel = '°C'
    else 
      params = {}
      @tlabel = '°F'
    end

    @forecast = ForecastIO.forecast(lat, lon, params: params)
  end

  class Day

    def initialize(forecast, tlabel)
      
      @forecast = forecast
      @x = forecast.currently
      @tlabel = tlabel

    end    
    
    def at(raw_hour)
      
      hour = Time.parse(raw_hour).hour
      i = 0
      i += 1 until Time.at(@forecast['hourly']['data'][i]['time']).hour \
                                                                  ==  hour.to_i
      @x = @forecast['hourly']['data'][i]
      self
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
      
    end

  end

  def today()
    Day.new(@forecast, @tlabel)
  end

  def tomorrow()
    
    # select tomorrow at midday
    i = 0
    i += 1 until Time.at(@forecast['hourly']['data'][i]['time']).hour ==  12
    DaysAhead.new(@forecast, @tlabel, index: i)
  end

end

