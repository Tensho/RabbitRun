require 'daemons'

pwd = File.dirname(File.expand_path(__FILE__))
stop_file = File.join(pwd,'stop')

$: << pwd 

FileUtils.rm_rf('/tmp/rabbitmq')
FileUtils.mkdir('/tmp/rabbitmq')

tasks = []

masters = Dir.glob("workers/*.rb")
masters.each do |master|
  tasks << Daemons.call(multiple: true, app_name: "RabbitRun") do
    require_relative master
  end
end

puts
puts "1. The system amqp workers have started (each process is called RabbitRun), browse to http://localhost:15672 and take a look at the connections, exchanges and queues that have been created. On the exchanges tab click on the filter.exchange and logger.exchange and take a not of the queues bound to those exchanges \n\n"
puts "2. In the next stage we run 'publisher.rb' that publishes messages to the Timestamp worker using bunny. Publisher uses Faker to randomly send a hash of data containing country: US, UK, UA; type: mail, name or phone number; severity: LOW MEDIUM HIGH\n\n"
puts "3. Make sure you have the queues tab open, when messages are being published you will be able to see the messages being processed by the workers. When the messages have stopped publishing you will be able to close the workers down from this console.\n\n"
puts "4. Hit <RETURN> to start publishing messages to RabbitMQ\n\n"
gets.chomp

puts "connecting to RabbitMQ, please wait a few seconds."

require 'publisher'

puts "5. When the workers have finished (no more activity in the Queues tab) you will see the output  in /tmp/rabbitmq/"

puts "Return to stop these processes"
puts "NOTE: if something goes wrong you can use `pkill RabbitRun` to kill any worker processes"
gets.chomp

tasks.each do |task|
  puts "stopping #{task}"
  task.stop
end

exit
