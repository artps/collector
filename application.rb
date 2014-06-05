$:.push(File.expand_path('../lib', __FILE__))
$:.push(File.expand_path('../application', __FILE__))

require 'collector'

require 'handlers'
require 'workers'
require 'connections'
require 'managers'

class Application < Collector::Application
  supervise WebhooksHandler,  as: :webhooks
  supervise EmployeesManager, as: :employees, args: [
    [
      {
        id: 1,
        connections: [
          { adapter: :facebook },
          { adapter: :github },
          { adapter: :dropbox }
        ]
      },
      {
        id: 2,
        connections: [
          { adapter: :facebook },
          { adapter: :github },
          { adapter: :dropbox }
        ]
      }
    ]
  ]
end

Application.run
