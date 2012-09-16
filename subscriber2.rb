require "amqp"

EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

  CHANNEL  = AMQP::Channel.new(connection)
  reader2_exchange = CHANNEL.fanout("reader2.exchange")
  queue_in    = CHANNEL.queue("reader2.2", :auto_delete => false).bind(reader2_exchange)
  queue_out    = CHANNEL.queue("subscriber2", :auto_delete => false)

  EXCHANGE = CHANNEL.direct("")

  queue_in.subscribe(:ack => true) do |metadata, payload|
    puts payload.inspect
    EXCHANGE.publish(payload, :key => "subscriber2")
    CHANNEL.acknowledge(metadata.delivery_tag, false)
  end

end