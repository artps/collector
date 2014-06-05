module Collector
  class Message
    attr_reader :namespace, :payload

    def initialize(namespace, payload)
      @namespace = namespace
      @payload = payload
    end
  end
end
