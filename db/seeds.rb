# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


comedies = Category.create(name: "Comdeies")
Video.create(title: "family_guy", description: "family_guy", small_cover_url: "/tmp/family_guy.jpg", category: comedies)
Video.create(title: "futurama", description: "futurama", small_cover_url: "/tmp/futurama.jpg", category: comedies)
Video.create(title: "monk", description: "monk", small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg", category: comedies)
Video.create(title: "south_park", description: "south_park", small_cover_url: "/tmp/south_park.jpg", category: comedies)
Video.create(title: "family_guy", description: "family_guy", small_cover_url: "/tmp/family_guy.jpg", category: comedies)
Video.create(title: "futurama", description: "futurama", small_cover_url: "/tmp/futurama.jpg", category: comedies)
Video.create(title: "monk", description: "monk", small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg", category: comedies)
Video.create(title: "south_park", description: "south_park", small_cover_url: "/tmp/south_park.jpg", category: comedies)