class Event < Struct.new(:regexp, :action); end

class Winston
  def initialize(&block)
    @events = []
    block.call(self) if block_given?
  end
  
  def on(regexp,&block)
    @events << Event.new(regexp, block)
  end
  
  def message(message_text,message)
    event = @events.find {|event| message_text.match(event.regexp) }
    if event
      args = message_text.match(event.regexp).to_a[1..-1]
      return event.action.call(message,args)
    end
  end
end

WINSTON = Winston.new do |winston|
  winston.on(/^I'm working on "(.*)"/i) do |message,args|
    project = args[0]
    person = Person.first(:email => message['user']['email_address'])
    unless person
      person = Person.create(:email=>message['user']['email_address'],:name=>message['user']['name'])
    end
    person.working_on(project)
    "#{message['user']['name']} working on \"#{project}\". Got it."
  end
  
  winston.on(/^hello/i) do |message,args|
    unless Person.first(:email => message['user']['email_address'])
      name = message['user']['name']
      Person.create(:email=>message['user']['email_address'],:name=>name)
      "Nice to meet you #{name}. Woof!"
    else
      "Woof!"
    end
  end
  
  winston.on(/^roll over/i) do |message,args|
    "Um. Do I look like that kind of dog? Woof!"
  end
  
  winston.on(/^fetch/i) do |message,args|
    "OK. Back soon. Woof!"
  end
end
