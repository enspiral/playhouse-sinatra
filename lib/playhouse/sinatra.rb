require 'playhouse/theatre'
require 'playhouse/production'
require 'playhouse/sinatra/api_builder'

module Playhouse
  module Sinatra
    def add_play theatre, play, routes=nil
      #theatre = Playhouse::Theatre.new(root: settings.root, environment: settings.environment)
      theatre.while_open do
        api = play.new
        settings.apis[api.name] = api
        settings.plays.concat Playhouse::Sinatra::ApiBuilder.build_sinatra_api(api, self)
        if routes
          set_routes(api, self, routes)
        end
      end
    end

    #expects routes to be a parsed yaml or equivalent
    #e.g. yaml
    #get:
    #  route: 'hello/:world'
    #  command: hello
    def set_routes(api, app, routes)
      routes.each do |k, v|
        app.send(k.to_sym, "/#{api.name}/#{v["route"]}") do
          settings.apis[api.name].send(v["command"].to_sym, params).to_json
        end 
      end 
      app.get '/routes' do
        str = ""
        str += "<table>"
        routes.each do |k, v| 
          str += "<tr>"
          str += "<td>"
          str += "#{k} : #{v["route"]} "
          str += "</td>"
          str += "<td>"
          str += "requires...etc"
          str += "</td>"
          str += "</tr>"
        end 
        str += "</table>"
        render :html, str 
      end
    end

    def self.registered(app)
      app.set :plays, []
      app.set :apis, {}

      app.get '/' do
        str = ""
        str += "<table>"
        settings.plays.each do |p| 
          str += "<tr>"
          str += "<td>"
          str += "#{p.keys.join(', ')}  "
          str += "</td>"
          str += "<td>"
          str += ":: #{p.values.join(', ')}"
          str += "</td>"
          str += "</tr>"
        end 
        str += "</table>"
        render :html, str 
      end
    end
  end
end
