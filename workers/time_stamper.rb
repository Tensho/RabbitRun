require "amqp"
require 'json'

EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

  CHANNEL  = AMQP::Channel.new(connection)
  
  exchange_in = CHANNEL.direct("published.exchange")
  queue_in    = CHANNEL.queue("timestamp", :auto_delete => false).bind(exchange_in)
  
  EXCHANGE_OUT = CHANNEL.fanout('timestamp.exchange', :auto_delete => false) 

  queue_in.subscribe(:ack => true) do |metadata, payload|
    data = JSON.parse(payload)
    data[:timestamp] = Time.now.to_i
    EXCHANGE_OUT.publish(JSON.generate(data))
    CHANNEL.acknowledge(metadata.delivery_tag, false)
  end

end
