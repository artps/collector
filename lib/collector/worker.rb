module Collector
  class Worker
    include Celluloid
    include Celluloid::Logger
    include Celluloid::Notifications

    class_attribute :_timers
    self._timers = []

    class << self

      def every(timeout, &block)
        self._timers = _timers.dup

        key = [self._timers.size, 'timers'].join('_').to_sym

        define_method(key) do
          instance_eval(&block)
        end

        self._timers << {
          timeout: timeout,
          handler: key
        }
      end

    end

    attr_reader :manager

    def initialize(manager)
      @manager = manager
      setup_timers
    end

    private

    def setup_timers
      _timers.each do |env|
        every(env[:timeout]) do
          async.send(env[:handler])
        end
      end
    end

  end
end
