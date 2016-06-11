# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

raspberry_pi = RaspberryPi.create!(name: 'Calm Dog')

# For some reason build isn't working eg raspberry_pi.home.build
Home.create!(raspberry_pi: raspberry_pi, address: '2005 43rd Ave E, 98112', radius: 5)
