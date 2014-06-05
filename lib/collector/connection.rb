module Collector

  class DummyManager
    def initialize(id)
      @id = id
    end

    def cast(*args)
      puts "WARNING: Manager with id = #{@id} isn't found…"
    end

    def async
      DummyManager.new(@id)
    end
  end

  class Connection
    include Celluloid
    include Celluloid::Logger
    include Celluloid::Notifications

    class_attribute :_handlers
    self._handlers = Hash.new { |hash, key| hash[key] = [] }

    class_attribute :_workers
    self._workers = []

    class << self

      def handle_cast(message, &handler)
        self._handlers = _handlers.dup

        handler_name = [message, self._handlers[message].size].join.to_sym

        define_method(handler_name) do |*args|
          instance_exec(args, &handler)
        end

        self._handlers[message] << handler_name
      end

      def worker(worker_class)
        self._workers = _workers.dup
        self._workers << worker_class
      end

      def manager(id)
        key = [name.downcase, id].join('_').to_sym
        actor = Celluloid::Actor[key]

        return DummyManager.new(id) unless actor

        actor
      end
    end

    attr_reader :manager

    def initialize(manager)
      @manager = manager
      @workers = []

      async.wait_for_messages
      register
      execute_workers
    end

    def cast(namespace, payload)
      Celluloid::Actor[key].mailbox << Message.new(namespace, payload)
    end

    private

    def execute_workers
      _workers.each do |worker_class|
        @workers << worker_class.new_link(current_actor)
      end
    end

    def register
      Celluloid::Actor[key] = current_actor
    end

    def key
      [self.class.name.downcase, @manager.id].join('_').to_sym
    end

    def wait_for_messages
      loop do
        receive do |message|
          _handlers[message.namespace].each do |handler|
            async.send(handler, message.payload)
          end
        end
      end
    end

  end
end
