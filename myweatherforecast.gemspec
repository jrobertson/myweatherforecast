Gem::Specification.new do |s|
  s.name = 'myweatherforecast'
  s.version = '0.4.0'
  s.summary = 'This gem is a wrapper of the forecast_io gem.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/myweatherforecast.rb']
  s.add_runtime_dependency('forecast_io', '~> 2.0', '>=2.0.0')
  s.add_runtime_dependency('geocoder', '~> 1.2', '>=1.2.11')
  s.signing_key = '../privatekeys/myweatherforecast.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/myweatherforecast'
end
