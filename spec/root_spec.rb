require 'rails_helper'

describe 'Root Welcome Endpoint', type: :request do
  it 'returns a welcome message' do
    get '/'

    expect(response).to be_successful
  end
end
