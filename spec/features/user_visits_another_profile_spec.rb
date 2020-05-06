require 'rails_helper'

RSpec.feature 'User visit to another user profile', type: :feature do

  let(:users) { create_pair :user}

  let!(:games) do
    [
      create(:game, id: 1, user: users.last, current_level: 14, prize: 40_000, created_at: 10.minutes.ago),
      create(:game, id: 2, user: users.last, current_level: 11, prize: 32_000, created_at: 30.minutes.ago, finished_at: Time.current, is_failed: true),
      create(:game, id: 3, user: users.last, current_level: 01, prize: 1_000,  created_at: 5.minutes.ago)
    ]
  end

  before(:each) do
    games.first.take_money!

    login_as users.first
  end

  scenario 'successfully visited others profile' do
    visit '/'

    click_link users.last.name

    expect(page).to have_current_path "/users/#{users.last.id}"

    expect(page).to have_content 'Дата'
    expect(page).to have_content 'Вопрос'
    expect(page).to have_content 'Выигрыш'
    expect(page).to have_content 'Подсказки'
    expect(page).not_to have_content 'Сменить имя и пароль'

    expect(page).to have_content users.first.name
    expect(page).to have_content users.last.name

    expect(page).to have_content 'в процессе'
    expect(page).to have_content 'проигрыш'
    expect(page).to have_content 'деньги'
  end
end
