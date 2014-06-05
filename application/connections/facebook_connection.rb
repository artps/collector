class FacebookConnection < Collector::Connection
  worker FacebookWorker

  handle_cast :friends_added do |data|
    info [@manager.id, 'Friends added'].inspect
  end

  handle_cast :message_added do |data|
    info [@manager.id, 'Message added'].inspect
  end
end
