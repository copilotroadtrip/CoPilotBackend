FactoryBot.define do
  factory :trip_poi do
    trip { nil }
    poi { nil }
    sequence_number { 1 }
  end
end
