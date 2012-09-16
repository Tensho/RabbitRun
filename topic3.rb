require "amqp"

EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

  CHANNEL  = AMQP::Channel.new(connection)
  subscriber2_exchange = CHANNEL.topic("subscriber2.exchange")
  queue_in    = CHANNEL.queue("subscriber2.3", :auto_delete => false).bind(subscriber2_exchange, :routing_key => "divide.by1")
  queue_out    = CHANNEL.queue("topic3", :auto_delete => false)

  EXCHANGE = CHANNEL.direct("")

  queue_in.subscribe(:ack => true) do |metadata, payload|
    puts payload.inspect
    EXCHANGE.publish(payload, :key => "topic3")
    CHANNEL.acknowledge(metadata.delivery_tag, false)
  end

end