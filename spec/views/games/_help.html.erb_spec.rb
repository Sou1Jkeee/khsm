require 'rails_helper'

RSpec.describe "games/_help", type: :view do
  let(:game) { build_stubbed(:game) }
  let(:help_hash) { { friend_call: 'Сергей считает что вариант D' } }

  it 'render help variant' do
    render_partial({}, game)

    expect(rendered).to match('50/50')
    expect(rendered).to match('fa-users')
    expect(rendered).to match('fa-phone')
  end

  it 'renders help info text' do
    render_partial(help_hash, game)

    expect(rendered).to match('Сергей считает что вариант D')
  end

  it 'does not render used help variant' do
    game.fifty_fifty_used = true

    render_partial(help_hash, game)

    expect(rendered).not_to match('50/50')
  end

  private

  def render_partial(help_hash, game)
    render partial: 'games/help', object: help_hash, locals: { game: game }
  end
end
