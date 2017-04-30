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

puts "1. The system amqp workers have started (each process is called RabbitRun), browse to http://localhost:15672 and take a look at the connections and queues that have been created\n\n"
puts "2. In the next stage we run a publisher that publishes 5000 messages to the workers. We use Faker to randomly send either an email, name or phone number\n\n"
puts "3. Make sure you have the queues tab open, when messages are being published you will be able to see the messages being processed by the workers. When the messages have stopped publishing you will be able to close the workers down from this console.\n\n"
puts "4. Hit <RETURN> to start publishing messages to RabbitMQ\n\n"
gets.chomp

puts "connecting to RabbitMQ, please wait a few seconds."

require 'publisher'

puts "5. When the workers have finished you will see five text files in /tmp/rabbitmq/"
puts "5.1 emails.txt, names.txt, phone_numbers.txt has been created by subscriber2 routing to topic1, topic2 and topic3 workers appropriatley"
puts "5.2 workers1.txt and workers2.txt should have the same number of messages but split so that no message appears in both txt files"

puts "Return to stop these processes"
gets.chomp

tasks.each do |task|
  puts "stopping #{task}"
  task.stop
end

exit
