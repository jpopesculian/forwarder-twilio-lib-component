module TwilioLibComponent
  module Handlers
    class Events
      include Log::Dependency
      include Messaging::Handle
      include Messaging::StreamName

      include Messages::Commands
      include Messages::Events

      dependency :write, Messaging::Postgres::Write
      dependency :clock, Clock::UTC

      def configure
        Messaging::Postgres::Write.configure(self)
        Clock::UTC.configure(self)
      end

      category :twilio_lib
    end
  end
end
