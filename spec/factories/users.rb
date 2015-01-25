FactoryGirl.define do
  factory :user do
    first_name "Feed"
    last_name "Reader"
    role  User::ROLE_INDIVIDUAL
    email "alert@ilabsea.org"
    phone "0975553553"
    password "password"
  end
end
