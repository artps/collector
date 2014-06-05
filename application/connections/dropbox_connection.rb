class DropboxConnection < Collector::Connection
  handle_cast :file_uploaded do |data|
    info [manager.id, 'file_uploaded', data].inspect
  end
end
