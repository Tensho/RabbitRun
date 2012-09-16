require "amqp"
require 'fileutils'
require './client.rb'

c = Client.new

(1..5000).each do |num|
  c.publish(num)
end

c.stop
