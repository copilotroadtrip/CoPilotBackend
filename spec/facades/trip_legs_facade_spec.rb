require 'rails_helper'

describe 'Trip Legs Facade spec' do
  before :each do
    # Generate a trip with status ready
    @trip = Trip.create
    @trip.status = 1
    @trip.save

    # Generate POIs in db
    @denver_poi = create(:poi,
      name: "Denver", state: "CO",
      ne_latitude: 39.914247, ne_longitude: -104.600302,
      sw_latitude: 39.614423, sw_longitude: -105.109924,
      population: 716492, land_area: "397024697", total_area: "401270097")

    @silverthorn_poi = create(:poi,
      name: "Silverthorne", state: "CO",
      ne_latitude: 39.690692, ne_longitude: -106.061701,
      sw_latitude: 39.623907, sw_longitude: -106.116307,
      population: 4821, land_area: "10417569", total_area: "10560564")

    @vail_poi = create(:poi,
      name: "Vail", state: "CO",
      ne_latitude: 39.652715, ne_longitude: -106.27488,
      sw_latitude: 39.61484, sw_longitude: -106.439436,
      population: 5450, land_area: "12098355", total_area: "12138320")

    # Add POIs to trip with sequence_number
    @trip.trip_pois.create(
      poi_id: @denver_poi.id,
      sequence_number: 1
    )

    @trip.trip_pois.create(
      poi_id: @silverthorn_poi.id,
      sequence_number: 2
    )

    @trip.trip_pois.create(
      poi_id: @vail_poi.id,
      sequence_number: 3
    )

    # Add Legs to trip between each POI
    @leg_1 = @trip.trip_legs.create(sequence_number: 1, distance: 100, duration: 60)
    @leg_2 = @trip.trip_legs.create(sequence_number: 2, distance: 150, duration: 90)
  end
  it 'Builds a response of trip data on places' do
    VCR.use_cassette("facades/trip_legs_facade/places") do
      places = FullTripFacade.new(@trip).places

      expect(places).to be_an(Array)
      expect(places.length).to eq(@trip.pois.length)

      expect(places[0][:id]).to              eq(@denver_poi.id)
      expect(places[0][:location][:lat]).to  eq(@denver_poi.center.lat)
      expect(places[0][:location][:lng]).to  eq(@denver_poi.center.lng)
      expect(places[0][:name]).to            eq(@denver_poi.name)
      expect(places[0][:state]).to           eq(@denver_poi.state)
      expect(places[0][:population]).to      eq(@denver_poi.population)
      expect(places[0][:weather]).to         be_a(Hash)
      expect(places[0][:sequence_number]).to eq(1)
    end
  end

  it 'Builds a response of trip data on legs' do
    VCR.use_cassette("facades/trip_legs_facade/legs") do
      legs = FullTripFacade.new(@trip).legs

      expect(legs).to        be_an Array
      expect(legs.length).to eq(@trip.trip_legs.length)

      expect(legs[0][:id]).to                eq(@leg_1.id)
      expect(legs[0][:sequence_number]).to   eq(@leg_1.sequence_number)
      expect(legs[0][:distance]).to          eq(@leg_1.distance)
      expect(legs[0][:duration_in_hours]).to eq(@leg_1.duration)
    end
  end

  it 'Builds a response combining the poi and leg data' do
    VCR.use_cassette("facades/trip_legs_facade/response") do
      response = FullTripFacade.new(@trip).response

      expect(response).to        be_a Hash
      expect(response[:data]).to be_a Hash

      expect(response[:data][:places]).to be_an Array
      expect(response[:data][:legs]).to   be_an Array
    end
  end
end
