require "amqp"

EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

  CHANNEL  = AMQP::Channel.new(connection)
  subscriber2_exchange = CHANNEL.topic("filter.exchange")
  queue_in    = CHANNEL.queue("uk_names", :auto_delete => false).bind(subscriber2_exchange, :routing_key => "UK.name.#")

  EXCHANGE = CHANNEL.direct("")

  queue_in.subscribe(:ack => true) do |metadata, payload|
    open('/tmp/rabbitmq/uk_names.txt', 'a') do |f|
      f.puts payload
    end
    CHANNEL.acknowledge(metadata.delivery_tag, false)
  end

end
