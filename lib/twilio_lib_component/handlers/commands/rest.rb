module TwilioLibComponent
  module Handlers
    class Commands
      class Rest
        include Log::Dependency
        include Messaging::Handle
        include Messaging::StreamName

        include Messages::Commands
        include Messages::Events

        dependency :write, Messaging::Postgres::Write
        dependency :clock, Clock::UTC
        dependency :store, Store

        def configure
          Messaging::Postgres::Write.configure(self)
          Clock::UTC.configure(self)
          Store.configure(self)
        end

        category :twilio_lib

        handle SmsFetchInitiate do |sms_fetch_initiate|
          request_id = sms_fetch_initiate.request_id

          request = store.fetch(request_id)

          if request.started?
            logger.info(tag: :ignored) { "Command ignored (Command: #{sms_fetch_initiate.message_type}, Request ID: #{request_id}, Message SID: #{sms_fetch_initiate.message_sid}" }
            return
          end

          stream_name = stream_name(request_id, 'twilioLib')

          time = clock.iso8601

          sms_fetch_initiated = SmsFetchInitiated.follow(sms_fetch_initiate)
          sms_fetch_initiated.processed_time = time
          write.(sms_fetch_initiated, stream_name)
        end
      end
    end
  end
end
