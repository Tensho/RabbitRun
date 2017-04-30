require "amqp"
require 'fileutils'
require 'client.rb'
require 'json'

def msg
  i = rand(3)
  val = case i
  when 0
    {value: Faker::Internet.email, type: :email}
  when 1
    {value: Faker::Name.name, type: :name}
  when 2
    {value: Faker::PhoneNumber.phone_number, type: :phone}
  end
  
  i = rand(3)
  case i
  when 0
    val[:country] = 'UK'
  when 1
    val[:country] = 'UA'
  when 2
    val[:country] = 'US'
  end 

  i = rand(3)
  case i 
  when 0
    val[:severity] = 'HIGH'
  when 1
    val[:severity] = 'MEDIUM'
  when 2
    val[:severity] = 'LOW'
  end

  JSON.generate(val)
end

c = Client.new

c.bunny.start

puts "publishing messages:"

(1..5000).each_with_index do |num, i|
  puts "published #{i} messages" if i % 100 == 0
  c.publish(msg)
end

c.stop
