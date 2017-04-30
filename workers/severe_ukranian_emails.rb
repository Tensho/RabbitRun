require "amqp"

EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

  CHANNEL  = AMQP::Channel.new(connection)
  exchange_in = CHANNEL.topic("filter.exchange")
  queue_in    = CHANNEL.queue("severe_ukranian_emails", :auto_delete => false).bind(exchange_in, :routing_key => "UA.email.HIGH")

  queue_in.subscribe(:ack => true) do |metadata, payload|
    open('/tmp/rabbitmq/severe_ukranian_emails.txt', 'a') do |f|
      f.puts payload
    end
    CHANNEL.acknowledge(metadata.delivery_tag, false)
  end

end
