require 'rails_helper'
require 'support/monkeypatch'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      build_stubbed(:user, name: 'User-1', balance: 5_000),
      build_stubbed(:user, name: 'User-2', balance: 3_000)
    ])

    render
  end

  it 'rendered player names' do
    expect(rendered).to match('User-1')
    expect(rendered).to match('User-2')
  end

  it 'rendered player balances' do
    expect(rendered).to match('5 000 ₽')
    expect(rendered).to match('3 000 ₽')
  end

  it 'rendered player names in right order' do
    expect(rendered).to match(/User-1.*User-2/m)
  end
end
