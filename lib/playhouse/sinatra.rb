require 'playhouse/theatre'
require 'playhouse/sinatra/api_builder'

module Playhouse
  module Sinatra
    def add_play play, routes=nil
      theatre = Playhouse::Theatre.new(root: settings.root, environment: settings.environment)
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
    #-
    #  get:
    #    route: 'hello/:world'
    #    command: hello
    #    params: '*world'
    #    description: hello world
    def set_routes(api, app, routes)
      routes.each do |route|
        route.each do |k, v|
          app.send(k.to_sym, "/#{api.name}/#{v["route"]}") do
            if ["put", "post", "patch"].include? k
              json ||= begin
                MultiJson.load(request.body.read.to_s, symbolize_keys: true)
              rescue MultiJson::LoadError
                {}
              end
              params.merge! json
            end
            settings.apis[api.name].send(v["command"].to_sym, params).to_json
          end 
        end
      end 
      app.get '/routes' do
        str = ""
        routes.each do |route| 
          route.each do |k, v|
            str += "<div style='margin-bottom: 25px;'>"
            str += "<h3 style='margin: 0 0 5px 0; font-weight: normal;'>"
            str += "<strong style='text-transform: uppercase;'>#{k}</strong> #{v["route"]}"
            str += "</h3>"
            str += "<p style='margin: 0 0 5px 0;'>"
            str += "params: #{v["params"]}"
            str += "</p>"
            str += "<p style='margin: 0 0 5px 0;'>"
            str += "#{v["description"]}"
            str += "</p>"
            str += "</div>"
          end
        end
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
