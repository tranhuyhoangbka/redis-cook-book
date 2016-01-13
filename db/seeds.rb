# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
10.times do
  User.create name: Faker::Name.name, age: rand(18..30), address: Faker::Address.street_address

end
30.times do
  Book.create title: Faker::Book.title, author: Faker::Book.author, desc: Faker::Lorem.sentence
end
