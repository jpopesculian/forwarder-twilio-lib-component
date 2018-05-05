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
        dependency :twilio_client, TwilioLibComponent::Utils::TwilioClient

        def configure
          Messaging::Postgres::Write.configure(self)
          Clock::UTC.configure(self)
          TwilioLibComponent::Utils::TwilioClient.configure(self)
        end

        category :twilio_lib

        handle SmsFetchInitiate do |sms_fetch_initiate|
          fetch_id = sms_fetch_initiate.fetch_id
          message_sid = sms_fetch_initiate.message_sid

          stream_name = stream_name(fetch_id, 'twilioLib')

          begin
            message = twilio_client.get_message(message_sid)

            time = clock.iso8601

            sms_fetched = SmsFetched.follow(sms_fetch_initiate)
            sms_fetched.to = message.to
            sms_fetched.from = message.from
            sms_fetched.body = message.body
            sms_fetched.processed_time = time

            write.(sms_fetched, stream_name)
          rescue Twilio::REST::TwilioError => error
            time = clock.iso8601

            sms_fetch_rejected = SmsFetchRejected.follow(sms_fetch_initiate)
            sms_fetch_rejected.error_message = error.message
            sms_fetch_rejected.processed_time = time

            write.(sms_fetch_rejected, stream_name)
          end
        end
      end
    end
  end
end
