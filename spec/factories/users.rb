require 'faker'

FactoryBot.define do
  # Фабрика, создающая юзеров
  factory :user do
    # Генерим рандомное имя
    name { Faker::Internet.unique.username }

    # email должен быть уникален — при каждом вызове фабрики n будет увеличен
    # поэтому все юзеры будут иметь разные адреса: someguy_1@example.com,
    # someguy_2@example.com, someguy_3@example.com ...
    sequence(:email) { Faker::Internet.unique.email }

    # Всегда создается с флажком false, ничего не генерим
    is_admin { false }

    # Всегда нулевой
    balance { 0 }

    # Коллбэк — после фазы :build записываем поля паролей, иначе Devise не
    # позволит создать юзера
    after(:build) { |u| u.password_confirmation = u.password = Faker::Internet.password(min_length: 8, max_length: 15) }
  end
end
