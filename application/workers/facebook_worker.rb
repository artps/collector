class FacebookWorker < Collector::Worker
  every(3) do
    manager.cast(:friends_added, {})
  end

  every(5) do
    manager.cast(:message_added, {})
  end
end
