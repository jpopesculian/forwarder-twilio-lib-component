module TwilioLibComponent
  module Start
    def self.call
      Consumers::Commands::Rest.start('twilioLibRest:command')
      Consumers::Commands.start('twilioLib:command')
      Consumers::Events.start('twilioLib')
    end
  end
end
