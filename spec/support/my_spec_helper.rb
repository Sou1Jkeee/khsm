module MySpecHelper
  # Наш хелпер, для населения базы нужным количеством рандомных вопросов
  def generate_questions(number)
    number.times do
      FactoryBot.create(:question)
    end
  end
end

RSpec.configure do |config|
  config.include MySpecHelper
end
