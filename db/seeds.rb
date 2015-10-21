# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
3.times do
  Video.create!(title: 'The Fierce Wife', description: 'The Fierce Wife', small_cover_url: '/tmp/the_fierce_wife.jpg', large_cover_url: '/tmp/the_fierce_wife_large.jpg', category_id: 1)
end
