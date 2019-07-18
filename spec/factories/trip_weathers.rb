FactoryBot.define do
  factory :trip_weather do
    time { 1 }
    summary { "MyString" }
    icon { "MyString" }
    temperature { 1.5 }
    precipProbability { 1.5 }
    precipIntensity { 1.5 }
    windSpeed { 1.5 }
    windGust { 1.5 }
    windBearing { 1 }
    trip { nil }
  end
end
