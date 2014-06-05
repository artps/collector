class WebhooksHandler < Collector::HTTP::Server
  post '/:employee_id/github' do |env|
    employee_id = env.params[:employee_id]
    data = JSON.parse(env.request.body)

    GithubConnection.manager(employee_id).async.cast(:issue_created, data)

    env.request.respond :ok, 'OK'
  end

  post '/:employee_id/dropbox' do |env|
    employee_id = env.params[:employee_id]
    data = JSON.parse(env.request.body)

    DropboxConnection.manager(employee_id).async.cast(:file_uploaded, data)

    env.request.respond :ok, 'OK'
  end
end
