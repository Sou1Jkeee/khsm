require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'validation check' do
    it { should validate_presence_of :text }

    it { should validate_presence_of :level }

    it { should validate_inclusion_of(:level).in_range(0..14) }

    it { should allow_value(14).for(:level) }

    it { should_not allow_value(15).for(:level) }

    subject { Question.new(text: 'some text', level: 0, answer1: '1', answer2: '2', answer3: '3', answer4: '4') }
    it { should validate_uniqueness_of(:text) }
  end
end
