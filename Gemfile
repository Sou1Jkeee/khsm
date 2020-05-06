source 'https://rubygems.org'

gem 'rails', '~> 4.2.10'

gem 'devise', git: 'https://github.com/plataformatec/devise', branch: '3-stable'
gem 'devise-i18n'

# Удобная админка для управления любыми сущностями
gem 'rails_admin'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'font-awesome-rails'
gem 'twitter-bootstrap-rails'
gem 'russian'

group :development, :test do
  gem 'sqlite3', '~> 1.3.13'
  gem 'byebug'
  gem 'rspec-rails', '~> 3.4'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
  gem 'faker'

  # Гем, который использует rspec, чтобы смотреть наш сайт
  gem 'capybara'

  # Гем, который позволяет смотреть, что видит capybara
  gem 'launchy'
end

group :production do
  # гем, улучшающий вывод логов на Heroku
  # https://devcenter.heroku.com/articles/getting-started-with-rails4#heroku-gems
  gem 'rails_12factor'
  gem 'pg'
end
