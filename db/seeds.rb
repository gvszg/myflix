# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
3.times do
  Video.create(title: 'Monk', description: 'A movie', small_cover_url: 'monk', large_cover_url: 'monk_large')
end


Category.create(name: 'TV Commedies')
Category.create(name: 'TV Dramas')
Category.create(name: 'Reality TV')