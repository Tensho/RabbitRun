require "amqp"
require 'json'

EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

  CHANNEL  = AMQP::Channel.new(connection)
  exchange_in = CHANNEL.fanout("timestamp.exchange")
  queue_in    = CHANNEL.queue("logs", :auto_delete => false).bind(exchange_in)

  EXCHANGE_OUT = CHANNEL.direct("logger.exchange")

  queue_in.subscribe(:ack => true) do |metadata, payload|
    data = JSON.parse(payload)
    #This is a Direct Exchange so any consumers must have an exact match to the routing_key 
    #(In this case HIGH, MEDIUM or LOW)
    puts data['severity']
    EXCHANGE_OUT.publish(payload, routing_key: data['severity']) #publishing to the split queue
    CHANNEL.acknowledge(metadata.delivery_tag, false)
  end

end
