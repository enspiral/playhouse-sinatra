module Playhouse
  module Sinatra
    class CommandBuilder
      def initialize api, sinatra_app
        @api = api
        @app = sinatra_app
      end
      def build_command(command)
        build_sinatra_calls(@api.name, command)
        {"/#{@api.name}/#{command.method_name}" => build_options(command)}
      end

      private

      def build_sinatra_calls(api_name, command)
        command_name = command.method_name
        command.http_methods.each do |method|
          @app.send(method, "/#{api_name}/#{command_name}") do
            settings.apis[api_name].send(command_name.to_sym, params).to_json
          end
        end
      end

      def build_options(command)
        options = []
        command.parts.each do |part|
          options << option_name(part)
        end
        options
      end

      def option_name(part)
        part.repository ? "#{part.name}_id" : part.name
      end
    end
  end
end