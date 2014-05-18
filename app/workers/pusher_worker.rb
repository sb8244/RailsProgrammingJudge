class PusherWorker
  include Sidekiq::Worker

  def perform(channel, event, args)
    Pusher.trigger(channel, event, args)
  end

end
