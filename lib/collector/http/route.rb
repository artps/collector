module Collector
  module HTTP

    class Route

      attr_reader :handler, :params

      def initialize(pattern, handler)
        @pattern = compile(pattern)
        @handler = handler
        @params  = {}
      end

      def match(path)
        found = @pattern.match(path)
        return unless found

        @params = {}.tap do |params|
          found.names.each do |name|
            params[name.to_sym] = found[name]
          end
        end

        self
      end

      private

      def compile(pattern)
        Regexp.new("^#{translate(pattern)}(\/|)$")
      end

      def translate(pattern)
        pattern.gsub(/\:(\w+)/, '(?<\1>\w+)')
      end
    end

  end
end
