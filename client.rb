require "bunny"
require "faker"

class Client
  
  def bunny
    @bunny ||= Bunny.new
  end

  def channel
    @channel ||= bunny.create_channel
  end

  def exchange
    @exchange || channel.direct("published.exchange")
  end

  def queue
    channel.queue("published", :auto_delete => false)
  end
   
  def publish(msg)
    # publish a message to the exchange which then gets routed to the queue
    exchange.publish(msg)
  end
  
  def stop
    # close the connection
    bunny.stop
  end
end
