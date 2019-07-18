class TripWorker
  include Sidekiq::Worker

  def perform(*args)
    puts 'Hello World'
  end

  def self.one
    1
  end
end
