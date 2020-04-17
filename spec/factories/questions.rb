require 'faker'

FactoryBot.define do
  factory :question do
    sequence(:text) { |n| "#{Faker::ChuckNorris.fact} #{n}?" }

    sequence(:level) { |n| n % 15 }

    answer1 { Faker::Number.number(digits: 4).to_s }
    answer2 { Faker::Number.number(digits: 4).to_s }
    answer3 { Faker::Number.number(digits: 4).to_s }
    answer4 { Faker::Number.number(digits: 4).to_s }
  end
end
