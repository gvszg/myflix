Fabricator(:user) do 
  email { Faker::Internet.email }
  username { Faker::Name.name }
  password { Faker::Internet.password }
end