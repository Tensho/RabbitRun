require "bunny"

class Client
  
  def b
    @b ||= Bunny.new
  end
  
  def initialize
    # start a communication session with the amqp server
    b.start
    # declare a queue
    q = b.queue("publisher", :auto_delete => false)
  end
  
  def exchange
    @e ||= b.exchange("")
  end
   
  def publish(msg)
    # publish a message to the exchange which then gets routed to the queue
    exchange.publish("Hello, everybody! #{msg}", :key => "publisher")
  end
  
  def stop
    # close the connection
    b.stop
  end
end
