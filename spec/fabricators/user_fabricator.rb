Fabricator(:user) do 
  email { Faker::Internet.email }
  username { Faker::Name.name }
  password { Faker::Internet.password }
  admin false
end

Fabricator(:admin, from: :user) do
  admin true
end