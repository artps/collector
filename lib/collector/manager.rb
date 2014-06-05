module Collector
  class Manager
    include Celluloid
    include Celluloid::Logger
    include Celluloid::Notifications
  end
end
