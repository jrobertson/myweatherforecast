Gem::Specification.new do |s|
  s.name = 'myweatherforecast'
  s.version = '1.0.3'
  s.summary = 'This gem is a wrapper of the forecast_io gem.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/myweatherforecast.rb']
  s.add_runtime_dependency('forecast_io', '~> 2.0', '>=2.0.2')
  s.add_runtime_dependency('geocoder', '~> 1.6', '>=1.6.2')
  s.add_runtime_dependency('emoji2020', '~> 0.2', '>=0.2.0')
  s.signing_key = '../privatekeys/myweatherforecast.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/myweatherforecast'
end
