# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product.delete_all
Product.create! id: 1, title: "Iron Helmet", price: 79.99, inventory_count: 25
Product.create! id: 2, title: "Hylian Shield", price: 1333.37, inventory_count: 1
Product.create! id: 3, title: "Leather Boots", price: 16.99, inventory_count: 10
Product.create! id: 4, title: "Mythical Chainmail", price: 99.99, inventory_count: 0
