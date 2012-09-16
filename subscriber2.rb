require "amqp"

EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

  CHANNEL  = AMQP::Channel.new(connection)
  reader2_exchange = CHANNEL.fanout("reader2.exchange")
  queue_in    = CHANNEL.queue("reader2.2", :auto_delete => false).bind(reader2_exchange)
  queue_out    = CHANNEL.queue("subscriber2", :auto_delete => false)

  EXCHANGE = CHANNEL.topic("subscriber2.exchange")

  queue_in.subscribe(:ack => true) do |metadata, payload|
    #puts payload.inspect
    
    index = payload.gsub(/[^\d]+/,"").to_i
    
    if index % 100 == 0
      rk = "divide.by100"
    elsif index % 10 == 0
      rk = "divide.by10"
    else
      rk = "divide.by1"
    end
    
    puts rk.inspect
    
    EXCHANGE.publish(payload, :routing_key => rk)
    CHANNEL.acknowledge(metadata.delivery_tag, false)
  end

end