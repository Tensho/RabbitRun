require "amqp"
require 'json'

EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

  CHANNEL = AMQP::Channel.new(connection)
  exchange_in = CHANNEL.direct("logger.exchange")
  queue_in = CHANNEL.queue("medium_logfile", :auto_delete => false).bind(exchange_in, routing_key: 'MEDIUM')
  
  queue_in.subscribe(:ack => true) do |metadata, payload|
    open('/tmp/rabbitmq/medium.log', 'a') do |f|
      f.puts payload
    end
    CHANNEL.acknowledge(metadata.delivery_tag, false)
  end

end
