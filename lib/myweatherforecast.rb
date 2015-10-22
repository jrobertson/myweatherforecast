#!/usr/bin/env ruby

# file: myweatherforecast.rb

require 'forecast_io'

# This gem is a wrapper of the forecast_io gem
# SI explained: https://en.wikipedia.org/wiki/SI_derived_unit

class MyWeatherForecast

  def initialize(lat, lon, api_key: nil, si: true)

    ForecastIO.api_key = api_key
  

    if si then
      params = { units: 'si' }
      @tlabel = 'degrees Celcius'
    else 
      params = {}
      @tlabel = 'degrees Farenheit'
    end

    @forecast = ForecastIO.forecast(lat, lon, params: params)
  end

  class Day

    def initialize(x, tlabel)
      
      @x = x
      @tlabel = tlabel

    end

    def to_s
      "%s %s, %s" % [@x.temperature.round, @tlabel, @x.summary]
    end

    def summary()
      @x.summary
    end

    def temperature
      @x.temperature
    end
  end

  class DaysAhead

    def initialize(x, tlabel)
      
      @x = x
      @tlabel = tlabel

    end

    def to_s
      "%s" % [@x.summary]
    end

    def summary()
      @x.summary
    end

  end

  def today()
    Day.new(@forecast.currently, @tlabel)
  end

  def tomorrow()
    DaysAhead.new(@forecast['daily']['data'][1], @tlabel)
  end

end

