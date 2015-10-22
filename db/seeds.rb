# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
commedies = Category.create(name: "TV Commedies")
dramas = Category.create(name: "TV Dramas")
reality = Category.create(name: "Reality TV")

Video.create!(title: 'The Fierce Wife', description: 'The Fierce Wife', small_cover_url: '/tmp/the_fierce_wife.jpg', large_cover_url: '/tmp/the_fierce_wife_large.jpg', category: commedies)

Video.create!(title: 'Black and White', description: 'Black and White', small_cover_url: '/tmp/black_and_white.jpg', large_cover_url: '/tmp/black_and_white_large.jpg', category: commedies)

Video.create!(title: 'In Time With You', description: 'In Time With You', small_cover_url: '/tmp/in_time_with_you.jpg', large_cover_url: '/tmp/in_time_with_you_large.jpg', category: commedies)

Video.create!(title: 'Monk', description: 'Monk', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category: commedies)

Video.create!(title: 'Monk', description: 'Monk', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category: dramas)

Video.create!(title: 'Futurama', description: 'Futurama', small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/futurama_large.jpg', category: dramas)

Video.create!(title: 'The Fierce Wife', description: 'The Fierce Wife', small_cover_url: '/tmp/the_fierce_wife.jpg', large_cover_url: '/tmp/the_fierce_wife_large.jpg', category: commedies)

Video.create!(title: 'Black and White', description: 'Black and White', small_cover_url: '/tmp/black_and_white.jpg', large_cover_url: '/tmp/black_and_white_large.jpg', category: commedies)

Video.create!(title: 'In Time With You', description: 'In Time With You', small_cover_url: '/tmp/in_time_with_you.jpg', large_cover_url: '/tmp/in_time_with_you_large.jpg', category: commedies)

Video.create!(title: 'Monk', description: 'Monk', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category: commedies)

Video.create!(title: 'Monk', description: 'Monk', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category: dramas)

Video.create!(title: 'Futurama', description: 'Futurama', small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/futurama_large.jpg', category: dramas)