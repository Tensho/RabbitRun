require "amqp"

EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

  CHANNEL  = AMQP::Channel.new(connection)
  queue_in    = CHANNEL.queue("publisher", :auto_delete => false)
  queue_out    = CHANNEL.queue("reader1", :auto_delete => false)

  EXCHANGE = CHANNEL.direct("")

  queue_in.subscribe(:ack => true) do |metadata, payload|
    puts payload.inspect
    EXCHANGE.publish(payload, :key => "reader1")
    CHANNEL.acknowledge(metadata.delivery_tag, false)
  end

end
