module TwilioLibComponent
  module Handlers
    class Commands
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

      handle SmsFetch do |sms_fetch|
        request_id = sms_fetch.request_id

        sms_fetch_initiate = SmsFetchInitiate.follow(sms_fetch)

        stream_name = stream_name(request_id, 'twilioLibRest:command')

        Try.(MessageStore::ExpectedVersion::Error) do
          write.initial(sms_fetch_initiate, stream_name)
        end
      end
    end
  end
end
