require 'rails_helper'
require 'support/my_spec_helper'

RSpec.describe Game, type: :model do
  let(:user) { create(:user) }
  let(:game_with_questions) { create(:game_with_questions, user: user) }

  describe 'Game Factory' do
    it 'Game.create_game_for_user! new correct game' do
      generate_questions(60)

      game = nil
      expect {
        game = Game.create_game_for_user!(user)
      }.to change(Game, :count).by(1).and(
        change(GameQuestion, :count).by(15)
      )

      expect(game.user).to eq(user)
      expect(game.status).to eq(:in_progress)

      expect(game.game_questions.size).to eq(15)
      expect(game.game_questions.map(&:level)).to eq (0..14).to_a
    end
  end

  describe 'Game mechanics' do
    it 'answer_correct_continues' do
      level = game_with_questions.current_level
      question = game_with_questions.current_game_question

      expect(game_with_questions.status).to eq(:in_progress)

      game_with_questions.answer_current_question!(question.correct_answer_key)

      expect(game_with_questions.current_level).to eq(level + 1)

      expect(game_with_questions.previous_game_question).to eq(question)
      expect(game_with_questions.current_game_question).not_to eq(question)

      expect(game_with_questions.status).to eq(:in_progress)
      expect(game_with_questions.finished?).to be_falsey
    end

    it '.take_money!' do
      game_with_questions.current_level = Question::QUESTION_LEVELS.to_a[12]
      game_with_questions.take_money!

      expect(game_with_questions.prize).to eq Game::PRIZES[game_with_questions.current_level - 1]
      expect(user.balance).to eq game_with_questions.prize
      expect(game_with_questions.finished?).to be_truthy
    end

    it '.current_game_question' do
      expect(game_with_questions.current_game_question).to eq(game_with_questions.game_questions[0])
    end

    it '.previous_level' do
      game_with_questions.current_level = Question::QUESTION_LEVELS.to_a.sample
      expect(game_with_questions.previous_level).to eq(game_with_questions.current_level - 1)
    end

    context '.status' do
      before(:each) do
        game_with_questions.finished_at = Time.now
        expect(game_with_questions.finished?).to be_truthy
      end

      it ':won' do
        game_with_questions.current_level = Question::QUESTION_LEVELS.max + 1
        expect(game_with_questions.status).to eq(:won)
      end

      it ':fail' do
        game_with_questions.is_failed = true
        expect(game_with_questions.status).to eq(:fail)
      end

      it ':timeout' do
        game_with_questions.created_at = 2.hours.ago
        game_with_questions.is_failed = true
        expect(game_with_questions.status).to eq(:timeout)
      end

      it ':money' do
        expect(game_with_questions.status).to eq(:money)
      end
    end

    describe '.answer_current_question!' do
      context 'when answer is correct' do
        let(:correct_answer) { game_with_questions.current_game_question.correct_answer_key }
        before { game_with_questions.answer_current_question!(correct_answer) }

        it 'and question is last' do
          game_with_questions.current_level = Question::QUESTION_LEVELS.max

          expect(game_with_questions.answer_current_question!(correct_answer)).to be true
          expect(game_with_questions.finished?).to be true
          expect(game_with_questions.status).to eq(:won)
          expect(game_with_questions.prize).to eq(Game::PRIZES.last)
        end

        it 'and timeout' do
          game_with_questions.created_at = 2.hour.ago

          expect(game_with_questions.answer_current_question!(correct_answer)).to be false
          expect(game_with_questions.finished?).to be true
          expect(game_with_questions.status).to eq(:timeout)
        end

        it 'and change level' do
          expect { game_with_questions.answer_current_question!(correct_answer) }
                   .to change(game_with_questions, :current_level)
        end
      end

      context 'when answer is wrong' do
        let(:wrong_answer) { 'wrong answer' }
        before { game_with_questions.answer_current_question!(wrong_answer) }

        it 'and game status fail' do
          expect(game_with_questions.answer_current_question!(wrong_answer)).to be false
          expect(game_with_questions.finished?).to be true
          expect(game_with_questions.status).to eq(:fail)
        end
      end
    end
  end
end
