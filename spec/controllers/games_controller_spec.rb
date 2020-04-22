require 'rails_helper'
require 'support/my_spec_helper'
require 'support/monkeypatch'

RSpec.describe GamesController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user, is_admin: true) }
  let(:game_with_questions) { create(:game_with_questions, user: user) }

  context 'Anon' do
    it 'kicked from #show' do
      get :show, id: game_with_questions.id
      game = assigns(:game)

      expect(game).to eq nil
      expect(response.status).not_to eq(200)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to be
    end

    it 'kicked from #create' do
      post :create
      game = assigns(:game)

      expect(game).to eq nil
      expect(response.status).not_to eq(200)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to be
    end

    it 'kicked from #answer' do
      put :answer, id: game_with_questions.id, letter: game_with_questions.current_game_question.correct_answer_key
      game = assigns(:game)

      expect(game).to eq nil
      expect(response.status).not_to eq(200)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to be
    end

    it 'kicked from #help' do
      put :help, id: game_with_questions.id, help_type: :fifty_fifty
      game = assigns(:game)

      expect(game).to eq nil
      expect(response.status).not_to eq(200)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to be
    end

    it 'kicked from #take_money' do
      put :take_money, id: game_with_questions.id
      game = assigns(:game)

      expect(game).to eq nil
      expect(response.status).not_to eq(200)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to be
    end
  end

  context 'Usual user' do
    before(:each) do
      sign_in user
    end

    it 'creates game' do
      generate_questions(60)
      post :create
      game = assigns(:game)

      expect(game.finished?).to be false
      expect(game.user).to eq(user)
      expect(response).to redirect_to game_path(game)
      expect(flash[:notice]).to be
    end

    it 'show game' do
      get :show, id: game_with_questions.id
      game = assigns(:game)

      expect(game.finished?).to be false
      expect(game.user).to eq(user)
      expect(response.status).to eq(200)
      expect(response).to render_template('show')
    end

    it 'answer correct' do
      put :answer, id: game_with_questions.id, letter: game_with_questions.current_game_question.correct_answer_key

      game = assigns(:game)

      expect(game.finished?).to be false
      expect(game.current_level).to be > 0
      expect(response).to redirect_to(game_path(game))
      expect(flash.empty?).to be true
    end

    it 'alien game' do
      alien_game = create(:game_with_questions)
      get :show, id: alien_game.id

      expect(response.status).not_to eq(200)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to be
    end

    it '#take money' do
      game_with_questions.update_attribute(:current_level, 10)
      put :take_money, id: game_with_questions.id
      game = assigns(:game)

      expect(game.finished?).to be true
      expect(game.prize).to eq(32_000)

      user.reload

      expect(user.balance).to eq(32_000)
      expect(response).to redirect_to(user_path(user))
      expect(flash[:warning]).to be
    end

    it 'try to create second game' do
      expect(game_with_questions.finished?).to be false

      expect { post :create }.to change(Game, :count).by(0)

      expect(response).to redirect_to(game_path(game_with_questions))
      expect(flash[:alert]).to be
    end
  end
end
