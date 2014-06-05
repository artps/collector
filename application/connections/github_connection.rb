class GithubConnection < Collector::Connection
  handle_cast :issue_created do |data|
    info [@manager.id, 'issue_created', data].inspect
  end
end
