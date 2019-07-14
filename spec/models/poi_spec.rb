require 'rails_helper'

RSpec.describe Poi, type: :model do
  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :ne_latitude }
    it { should validate_presence_of :ne_longitude }
    it { should validate_presence_of :sw_latitude }
    it { should validate_presence_of :sw_longitude }
  end
end
