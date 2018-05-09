module TwilioLibComponent
  module Commands
    class SmsFetch
      include Command

      def self.configure(receiver, attr_name: nil)
        attr_name ||= :sms_fetch
        instance = build
        receiver.public_send("#{attr_name}=", instance)
      end

      def self.call(message_sid:, request_id: nil, time: nil, reply_stream_name: nil, previous_message: nil)
        request_id ||= Identifier::UUID::Random.get
        time ||= Clock::UTC.iso8601
        instance = self.build
        instance.(
          request_id: request_id,
          message_sid: message_sid,
          time: time,
          reply_stream_name: reply_stream_name,
          previous_message: previous_message
        )
      end

      def call(request_id:, message_sid:, time:, reply_stream_name: nil, previous_message: nil)
        sms_fetch = self.class.build_message(Messages::Commands::SmsFetch, previous_message)

        sms_fetch.request_id = request_id
        sms_fetch.message_sid = message_sid
        sms_fetch.time = time

        stream_name = command_stream_name(request_id)

        write.(sms_fetch, stream_name, reply_stream_name: reply_stream_name)

        sms_fetch
      end
    end
  end
end
