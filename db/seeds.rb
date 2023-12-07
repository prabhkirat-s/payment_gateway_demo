# Load Faker
require 'faker'

# Create 10 fake products with images
10.times do
  product = Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph,
    price: Faker::Commerce.price,
    image_url: Faker::LoremFlickr.image(size: "300x300", search_terms: ['product'])
  )
end unless Product.exists?



10.times do
  User.create!(
    full_name: Faker::Name.name,
    email: Faker::Internet.email
  )
end unless User.exists?