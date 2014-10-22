# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
Step.delete_all

jinni = User.create
jinni.id = "jinniahn@gmail.com"
jinni.email = "jinniahn@gmail.com"
jinni.password = "test1234"
jinni.save

0.upto(10).each do |i|
  step = Step.new
  step.time = 1.hour.ago + i * ( 3600 / 10 )
  step.period = 5000
  step.steps = rand(5..10)
  step.user = jinni
  step.save
end

0.upto(100).each do |i|

  step = Step.new
  step.time = 30.minute.ago + 60 * i
  step.period = 5000
  step.steps = rand(5..10)
  step.user = jinni
  step.save

end


