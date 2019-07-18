FactoryBot.define do
  factory :trip_leg do
    trip { nil }
    distance { 1 }
    duration { 1.5 }
    sequence_number { 1 }
  end
end
