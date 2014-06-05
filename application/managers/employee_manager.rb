class EmployeeManager < Collector::Manager

  class << self
    def run(id, connections)
      supervise_as(key(id), id, connections)
    end

    def key(id)
      [name.downcase, id].join('_').to_sym
    end
  end

  attr_reader :id

  def initialize(id, connections)
    @id = id
    @connections = connections
    @workers = Hash.new { |hash, key| hash[key] = [] }

    async.run
  end

  def run
    run_connection_actors
  end

  def run_connection_actors
    @connections.each do |connection|
      @workers[connection[:adapter]] << connection_class(connection[:adapter]).new_link(current_actor)
    end
  end

  def connections_map
    @_connections_map ||= {
      github: GithubConnection,
      dropbox: DropboxConnection,
      facebook: FacebookConnection
    }
  end

  def connection_class(name)
    connections_map[name]
  end
end
