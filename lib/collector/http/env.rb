module Collector
  module HTTP

    class Env
      attr_reader :request, :params

      def initialize(request, params)
        @request = request
        @params  = params
      end
    end

  end
end
