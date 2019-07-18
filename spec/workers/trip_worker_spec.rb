require 'rails_helper'
RSpec.describe TripWorker, type: :worker do
  it 'Prints hello world' do
    TripWorker.perform_async()

    expect(1).to eq(1)
  end
end
