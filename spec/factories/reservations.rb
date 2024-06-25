FactoryBot.define do
  factory :reservation do
    client
    slot

    trait :expired do
      expired { true }
    end

    trait :confirmed do
      confirmed { true }
      confirmed_at { Time.now }
    end
  end
end
