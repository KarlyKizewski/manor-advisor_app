FactoryBot.define do 
  factory :user do
    sequence :email do |n|
      "tester#{n}@gmail.com"
    end
    password { "password" }
    password_confirmation { "password" }
  end

  factory :task do
    message { "hello" }
    association :user
  end

  factory :clean do
    message { "clean" }
    association :user
  end
end