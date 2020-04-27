require 'rails_helper'

RSpec.describe GameQuestion, type: :model do
  let(:game_question) { create(:game_question, a: 2, b: 1, c: 4, d: 3) }

  context 'game status' do
    it 'correct .variants' do
      expect(game_question.variants).to eq(
        {
          'a' => game_question.question.answer2,
          'b' => game_question.question.answer1,
          'c' => game_question.question.answer4,
          'd' => game_question.question.answer3
        }
      )
    end

    it 'correct .answer_correct?' do
      expect(game_question.answer_correct?('b')).to be_truthy
    end
  end

  it 'help_hash' do
    expect(game_question.help_hash).to eq({})

    game_question.help_hash[:key1] = 'value1'
    game_question.help_hash[:key2] = 'value2'

    expect(game_question.save).to be true

    game_q = GameQuestion.find(game_question.id)

    expect(game_q.help_hash).to eq({ key1: 'value1', key2: 'value2' })
  end

  context 'delegates methods' do
    it 'correct .level and .text delegates' do
      expect(game_question.text).to eq(game_question.question.text)
      expect(game_question.level).to eq(game_question.question.level)
    end
  end

  context 'correct answer methods' do
    it '.correct_answer_key' do
      expect(game_question.correct_answer_key).to eq('b')
    end

    it '.correct_answer equal question answer' do
      expect(game_question.correct_answer).to eq(game_question.question.answer1)
    end
  end

  context 'user helpers' do
    it 'correct audience_help' do
      expect(game_question.help_hash).not_to include(:audience_help)

      game_question.add_audience_help

      expect(game_question.help_hash).to include(:audience_help)
      expect(game_question.help_hash[:audience_help].keys).to contain_exactly('a', 'b', 'c', 'd')
    end

    it 'correct fifty_fifty' do
      expect(game_question.help_hash).not_to include(:fifty_fifty)

      game_question.add_fifty_fifty
      fifty_fifty = game_question.help_hash[:fifty_fifty]

      expect(fifty_fifty).to include('b')
      expect(fifty_fifty.size).to eq(2)
    end

    it 'correct friend_call' do
      expect(game_question.help_hash).not_to include(:friend_call)

      game_question.add_friend_call

      expect(game_question.help_hash[:friend_call]).to match('считает, что это вариант')
    end
  end
end
