#Playhouse Sinatra

Automatically create a json api to your playhouse app using sinatra.

[![Code Climate](https://codeclimate.com/github/enspiral/playhouse-sinatra.png)](https://codeclimate.com/github/enspiral/playhouse-sinatra)
[![Build Status](https://travis-ci.org/enspiral/playhouse-sinatra.png)](https://travis-ci.org/enspiral/playhouse-sinatra)
[![Coverage Status](https://coveralls.io/repos/enspiral/playhouse-sinatra/badge.png?branch=master)](https://coveralls.io/r/enspiral/playhouse-sinatra)

##Status

Still in development, not recommended for production use

##Installation

```ruby
  gem 'playhouse-sinatra', git: 'git://github.com/enspiral/playhouse-sinatra.git'
```

##Usage

see the [economatic-sinatra](https://github.com/enspiral/economatic/tree/master/economatic_sinatra) app for a demonstration

You can setup your Sinatra app with something along the lines of

```ruby
require 'sinatra/base'
require 'playhouse/sinatra'
require 'economatic/api'

class EconomaticWeb < Sinatra::Base
  register Playhouse::Sinatra
  set :root,  File.expand_path(File.join(File.dirname(__FILE__)))

  add_play Economatic::API

  run! if app_file == $0
end
```

##TODO

* API authentication
* API versioning
* separate out GET, POST, PUT, DELETE methods
* better documentation of api on root path

##Licence

Playhouse is licenced under the MIT licence. Copyright 2013 Enspiral Services Ltd.

##Contributing

Your contributions are welcome. Send us a pull request, or start a discussion in the github
issues first.

##Credits

From Enspiral Craftworks:

* Craig Ambrose (@craigambrose)
* Joshua Vial (@joshuavial)
