require "amqp"

EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

  CHANNEL  = AMQP::Channel.new(connection)
  in_exchange = CHANNEL.topic("filter.exchange")
  queue_in    = CHANNEL.queue("us_medium", :auto_delete => false).bind(in_exchange, :routing_key => "US.#.MEDIUM")

  EXCHANGE = CHANNEL.direct("")

  queue_in.subscribe(:ack => true) do |metadata, payload|
    open('/tmp/rabbitmq/us_medium.txt', 'a') do |f|
      f.puts payload
    end
    CHANNEL.acknowledge(metadata.delivery_tag, false)
  end

end
