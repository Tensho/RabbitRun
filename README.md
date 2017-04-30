RabbitRun
=========

An entirely fictitious system that demonstrates a simple RabbiMQ messaging architecture that uses both Bunny and the AMQP gem. The system generates 5000 random messages. 

One part of the system logs all of these messages into low, medium and high logs based on a severity parameter in the message.

The other part looks for and logs specific types of message ignoring the rest.

The system is very simple to run. Just install and start RabbitMQ from homebrew, run the app and follow the instructions in console.

    bundle exec ruby run.rb
    
The application can be [monitored in your browser](http://localhost:15672)

![rabbit run diagram](https://github.com/stevecreedon/RabbitRun/blob/master/RabbitRun.png)

RabbitMQ Test Lab