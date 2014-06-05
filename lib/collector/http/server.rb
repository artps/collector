module Collector
  module HTTP

    class Server < Reel::Server::HTTP
      include Celluloid::Logger

      class_attribute :routes
      self.routes = Hash.new{ |hash, key| hash[key] = [] }

      class << self

        def post(pattern, &handler)
          route(:post, pattern, &handler)
        end

        def get(pattern, &handler)
          route(:get, pattern, &handler)
        end

        def route(method, pattern, &handler)
          self.routes = routes.dup
          self.routes[method] << Route.new(pattern, handler.to_proc)
        end

      end


      def initialize(host = '127.0.0.1', port = 3000)
        super(host, port, &method(:on_connection))
      end

      def on_connection(connection)
        connection.each_request do |request|
          handle_request(request)
        end
      end

      def handle_request(request)
        route = match(request.method.downcase.to_sym, request.url)
        if route
          route.handler.call(Collector::HTTP::Env.new(request, route.params))
        else
          return request.respond :not_found, 'Not Found'
        end
      end

      private

      def match(method, url)
        routes[method].each do |route|
          found = route.match(url)
          return found if found
        end
      end

    end
  end
end
