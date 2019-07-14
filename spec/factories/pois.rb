FactoryBot.define do
  factory :poi do
    name { "MyString" }
    ne_latitude { 1.5 }
    ne_longitude { 1.5 }
    sw_latitude { 1.5 }
    sw_longitude { 1.5 }
  end
end
