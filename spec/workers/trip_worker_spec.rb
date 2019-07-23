require 'rails_helper'

RSpec.describe TripWorker, type: :worker do
  it 'Creates a new trip' do
    expect {
      TripWorker.perform_async
    }.to change(TripWorker.jobs, :size).by(1)

    # Clear all Sidekiq jobs after test runs
    Sidekiq::Worker.clear_all
  end
end
