if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
end

def stub_theatre
  theatre = Playhouse::Theatre.new(environment: 'test')
  theatre.stub(:open)
  Playhouse::Theatre.stub(:new).and_return(theatre)
end