# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Student.delete_all

Student.create :name => "John Smith", :year => 1, :sex => "Male", :country => "USA", :tuition_paid => 1000, :tuition_due => 3200
Student.create :name => "Anne Johnson", :year => 3, :sex => "Female", :country => "Sweden", :tuition_paid => 3200, :tuition_due => 0
Student.create :name => "Sally Jones", :year => 2, :sex => "female", :country => "Ireland", :tuition_pad => 2400, :tuition_due => 800
