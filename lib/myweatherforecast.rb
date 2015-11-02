#!/usr/bin/env ruby

# file: myweatherforecast.rb

require 'json'
require 'time'
require 'geocoder'
require 'forecast_io'
require 'open-uri'



# This gem is a wrapper of the forecast_io gem
# SI explained: https://en.wikipedia.org/wiki/SI_derived_unit

class MyWeatherForecast
  
  attr_reader :coordinates

  def initialize(*location, api_key: nil, units: :auto, timeout: 3, \
                                                               symbols: true)
    
    lat, lon = if location.length > 1 or location.is_a? Array then
    
      location
      
    elsif location.any?
      
      results = Geocoder.search(location.first)
      return puts 'location not found' unless results.any?
      results[0].coordinates
      
    else
      
      h = JSON.parse open('http://jsonip.com/').read
      Geocoder.configure(timeout: timeout)
      results = Geocoder.search(h['ip'])
      return puts 'could not determine location from IP address' unless \
                                                                   results.any?
      results[0].coordinates
                              
    end        

    ForecastIO.api_key = api_key

    params = { units: units.to_s }
    @forecast = ForecastIO.forecast(lat, lon, params: params)

    autounits = @forecast['flags']['units']
    
    @tlabel = if symbols then
      autounits == 'us' ? '°F' : '°C'
    else
      autounits == 'us' ? 'degrees Farenheit' : 'degrees Celcius'
    end
    
    @coordinates = [lat, lon]
    @symbols = symbols

  end

  class Hourly
    
    attr_reader :today

    def initialize(forecast, tlabel, i=0)
      
      @forecast, @tlabel, @i = forecast, tlabel, i
      
      @x, @hourly_data = if i > 0 then
        [forecast['hourly']['data'][i], forecast['hourly']['data'][i..-1]]
      else
        [forecast.currently, forecast['hourly']['data']]
      end

    end    
    
    def at(raw_hour)
      
      hour = Time.parse(raw_hour).hour
      i = 0

      return if Time.at(@hourly_data[i]['time']).hour > hour
      
      i += 1 until Time.at(@hourly_data[i]['time']).hour ==  hour

      Hourly.new(@forecast, @tlabel, i+@i)

    end
    
    def afternoon()   period(12, 17)                end    
    def early_hours() period(0, 5)                  end
    def evening()     period(17, night_time.hour+1) end
    def morning()     period(6, 12)                 end    
    def night()       period(night_time.hour, 23)   end
    
    def night_time()
      Time.at(@day.sunsetTime)
    end        
    
    def humidity()
      @x.humidity
    end
    
    def icon()
      @x.icon
    end
    
    def noon()
      at_hour 12
    end
    
    alias midday noon

    def to_s
      "%s: %d%s, %s" % [self.time.strftime("%-I%P"), @x.temperature.round, \
                                                          @tlabel, @x.summary]
    end

    def summary()
      @x.summary
    end
    
    def sunrise()
      @day.sunrise
    end
        
    def sunset()
      @day.sunset
    end    
    
    alias night_time sunset    
    
    def temperature
      "%s°" % @x.temperature.round
    end
    
    alias temp temperature
    
    def time
      Time.at @x.time
    end

    def visibility()
      @x.visibility
    end
    
    def windspeed()
      @x.windSpeed.round
    end
    
    private
    
    def at_hour(n)

      i = 0

      return if Time.at(@hourly_data[i]['time']).hour > n 
      len = @hourly_data.length
      i += 1 until Time.at(@hourly_data[i]['time']).hour ==  n or i >= len - 1

      Hourly.new(@forecast, @tlabel, i+@i)
    end
    
    def period(hr1, hr2)
      
      current_hour = Time.at(@hourly_data[0]['time']).hour      
      
      return if current_hour >= hr2
      
      hr1 = current_hour if current_hour > hr1
      hr2 = @hourly_data.length - 2 if hr2 + 1 > @hourly_data.length - 1
      (hr1..hr2).map {|n| at_hour n}
      
    end
    
  end
  
                                 
  class Daily < Hourly
                                 
    def initialize(forecast, tlabel, d=0)
      
      @forecast = forecast

      @x = forecast['daily']['data'][d]
      @tlabel = tlabel

      found = forecast['hourly']['data'].detect do |hour|
        Time.at(@x.time).to_date == Time.at(hour.time).to_date
      end
      
      @i = forecast['hourly']['data'].index found      
      
      return if @i.nil?

      @hourly_data = forecast['hourly']['data'][@i..-1]
      @day = self
                                      
    end
    
    def to_s
      
      label = self.time.to_date == Time.now.to_date ? 'Today' : \
                                            Date::ABBR_DAYNAMES[self.time.wday]
      
      mask = @symbols ? "%s: ▽%s ▲%s, %s" : "%s: %s %s, %s"
      mask % [label, tempmin, tempmax, @x.summary]
    end
    
    def sunrise()
      Time.at @x.sunriseTime
    end
    
    def sunset()
      Time.at @x.sunsetTime
    end    
    
    def temperature()
    end

    def tempmin
      "%s°" % [@x.temperatureMin.round]
    end
                                 
    def tempmax
      "%s°" % [@x.temperatureMax.round]
    end
    

  end
  
  
  # e.g.
  # require 'myweatherforecast'
  #
  # w = MyWeatherForecast.new api_key: '465xxxxxxxxxxxxxx76ea01cbff4'
  # puts w.days.take 3
  #
  # Fri: 8° - 14°, Mostly cloudy throughout the day.
  # Sat: 6° - 13°, Light rain until afternoon.
  # Sun: 5° - 12°, Mostly cloudy throughout the day.

  def days()
    (@forecast['daily']['data'].length).times.map {|n| Daily.new(@forecast, @tlabel, n) }
  end

  def hours()
    
    len = @forecast['hourly']['data'].length
    len.times.map {|i| Hourly.new @forecast, @tlabel, i}

  end
  
  def now()
    Hourly.new(@forecast, @tlabel)
  end
    
  def today()
    Daily.new(@forecast, @tlabel)
  end
  
  alias currently now  
  
  def tonight()
    Daily.new(@forecast, @tlabel).night
  end
        
  alias this today
  
  def tomorrow()    
    Daily.new(@forecast, @tlabel, 1)
  end 
  
  def monday()    day :monday    end
  def tuesday()   day :tuesday   end
  def wednesday() day :wednesday end
  def thursday()  day :thursday  end
  def friday()    day :friday    end
  def saturday()  day :saturday  end
  def sunday()    day :sunday    end
    
  alias sat saturday
  alias sun sunday
  alias mon monday
  alias tue tuesday
  alias wed wednesday
  alias thu thursday
  alias fri friday

  private
  
  def day(name)
    
    name = (name.to_s + '?').to_sym
                                 
    d = 0 
    d += 1 until Time.at(@forecast['daily']['data'][d].time).method(name).call
    Time.at(@forecast['daily']['data'][d].time)
    Daily.new(@forecast, @tlabel, d)
  end

end