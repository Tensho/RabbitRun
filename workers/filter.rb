require "amqp"
require 'json'

EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

  CHANNEL  = AMQP::Channel.new(connection)
  exchange_in = CHANNEL.fanout("timestamp.exchange")
  queue_in    = CHANNEL.queue("filters", :auto_delete => false).bind(exchange_in)

  EXCHANGE = CHANNEL.topic("filter.exchange")

  queue_in.subscribe(:ack => true) do |metadata, payload|
   
    data = JSON.parse(payload)
     
    routing_key = "#{data['country']}.#{data['type']}.#{data['severity']}"
    #This is a topic exchange so routing_keys must be dot separated and wild cards can be used by consumers
    #e.g. UK.email.LOW
    puts routing_key.inspect
    EXCHANGE.publish(payload, :routing_key => routing_key)
    CHANNEL.acknowledge(metadata.delivery_tag, false)
  end

end
