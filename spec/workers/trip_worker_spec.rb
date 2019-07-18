require 'rails_helper'

RSpec.describe TripWorker, type: :worker do
  it 'Creates a new trip' do
    expect {
      TripWorker.perform_async
    }.to change(TripWorker.jobs, :size).by(1)

    # Clear all Sidekiq jobs after test runs
    Sidekiq::Worker.clear_all
  end

  describe 'one' do
    it 'returns one - this is how we can test our methods' do
      expect(TripWorker.one).to eq(1)
    end
  end
end
