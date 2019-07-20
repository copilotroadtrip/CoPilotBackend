require 'rails_helper'

describe 'Trip Legs Facade spec' do
  before :each do
    @trip = Trip.create
    @trip.status = 1
    @trip.save

    @denver_poi = create(:poi,
      name: "Denver", state: "CO",
      ne_latitude: 39.914247, ne_longitude: -104.600302,
      sw_latitude: 39.614423, sw_longitude: -105.109924,
      population: 716492, land_area: "397024697", total_area: "401270097")

    @trip.trip_pois.create(
      poi_id: @denver_poi.id,
      sequence_number: 1
    )

    @silverthorn_poi = create(:poi,
    name: "Silverthorne", state: "CO",
    ne_latitude: 39.690692, ne_longitude: -106.061701,
    sw_latitude: 39.623907, sw_longitude: -106.116307,
    population: 4821, land_area: "10417569", total_area: "10560564")

    @trip.trip_pois.create(
      poi_id: @silverthorn_poi.id,
      sequence_number: 2
    )

    @vail_poi = create(:poi,
    name: "Vail", state: "CO",
    ne_latitude: 39.652715, ne_longitude: -106.27488,
    sw_latitude: 39.61484, sw_longitude: -106.439436,
    population: 5450, land_area: "12098355", total_area: "12138320")

    @trip.trip_pois.create(
      poi_id: @vail_poi.id,
      sequence_number: 3
    )
  end
  it 'Builds a response of trip data on places' do
    VCR.use_cassette("facades/trip_legs_facade") do
      places = TripLegsFacade.new(@trip).places

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
end
