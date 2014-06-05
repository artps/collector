require 'celluloid'
require 'reel'
require 'active_support/core_ext'

Celluloid.start

module Collector
  VERSION = '0.1.0'
end

require 'collector/application'
require 'collector/connection'
require 'collector/http'
require 'collector/manager'
require 'collector/message'
require 'collector/worker'
