require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    assign(:user, create(:user))

    assign(:games, [
      build_stubbed(:game, id: 12, created_at: Time.parse('2020.04.30, 14:00'), current_level: 2, prize: 1_500),
      build_stubbed(:game, id: 13, created_at: Time.parse('2020.04.30, 16:00'), current_level: 10, prize: 15_000)
    ])

    render
  end

  context 'anon user' do
    it 'renders user name' do
      expect(rendered).to match /#{:user}/
    end

    it 'users balances' do
      expect(rendered).to match '1 500 ₽'
      expect(rendered).to match '15 000 ₽'
    end

    it 'anon cant see profile links other user' do
      expect(rendered).not_to match /Сменить имя и пароль/
    end
  end

  context 'current user' do
    let(:user) { create(:user) }

    before(:each) do
      assign(:user, user)
      sign_in user

      render
    end

    it 'renders user name' do
      expect(rendered).to match /#{user.name}/
    end

    it 'user can see his profile links' do
      expect(rendered).to match /Сменить имя и пароль/
    end
  end
end
