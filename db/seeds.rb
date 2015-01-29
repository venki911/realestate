# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def parse_file(file)
  file_name = "#{Rails.root}/doc/#{file}"
  file_content = File.open(file_name){|f| f.read}
  file_content.lines
end

#Seed User
user_attributes = [ 
    { user_name: 'admin', email: 'admin@cochero.com', first_name: "admin", last_name: "Ly", phone: "0975553553", password: "password", role: User::ROLE_ADMIN },
    { user_name: 'agent', email: 'agent@cochero.com', first_name: "agent", last_name: "Ly", phone: "0975553553", password: "password", role: User::ROLE_AGENT },
    { user_name: 'individual', email: 'member@cochero.com', first_name: "individual", last_name: "Lee", phone: "0975553553", password: "password", role: User::ROLE_INDIVIDUAL} 
]

user_attributes.each do |attrs|
  user = User.where(email: attrs[:email]).first_or_initialize
  user.update_attributes(attrs.except(:email))
  user.save!
end

# Categories
categories = [ '3 Star Hotel', '4 Star Hotel', '5 Star Hotel', 'Boutique Hotel', 'Budget Hotel', 'Bungalow', 'Casino', 'Condominium',
     'Detached House', 'Factory', 'Flat', 'Guesthouse', 'Island', 'Land', 'Linkhouse', 'Office Building', 'Office Space',
     'Restaurant', 'Room', 'Semi-Detached House', 'Serviced Apartment', 'Warehouse', 'Wooden House' ]
     
ActiveRecord::Base.transaction do
  categories.each do |category_name|
    category = Category.where(name: category_name).first_or_initialize
    category.save! if category.new_record?
  end
end


# Province
ActiveRecord::Base.transaction do
  parse_file('province.txt').each do |line|
    line =~/\((.*)\)/
    columns = $1.split(",")
    place = Province.where(id: columns[0], name: columns[1]).first_or_initialize
    place.save!
  end
end

# District
ActiveRecord::Base.transaction do
  parse_file('district.txt').each do |line|
    line =~/\((.*)\)/
    columns = $1.split(",")
    place = District.where(id: columns[0], name: columns[1], province_id: columns[2]).first_or_initialize
    place.save!
  end
end

# Commune
ActiveRecord::Base.transaction do
  parse_file('commune.txt').each do |line|
    line =~/\((.*)\)/
    columns = $1.split(",")
    place = Commune.where(id: columns[0], name: columns[1], district_id: columns[2], province_id: columns[3]).first_or_initialize
    place.save!
  end
end
