# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Seed User
user_attributes = { email: 'admin@cochero.com', first_name: "admin", last_name: "Admin", phone: "0975553553", password: "password" }
user = User.where(email: user_attributes[:email]).first_or_initialize
user.update_attributes(user_attributes.except(:email))
user.save!

places = ["province.txt", "district.txt", "commune.txt"]


def parse_file(file)
  file_name = "#{Rails.root}/doc/#{file}"
  file_content = File.open(file_name){|f| f.read}
  file_content.lines
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



