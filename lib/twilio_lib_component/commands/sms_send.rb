module TwilioLibComponent
  module Commands
    class SmsSend
      include Command

      def self.configure(receiver, attr_name: nil)
        attr_name ||= :sms_send
        instance = build
        receiver.public_send("#{attr_name}=", instance)
      end

      def self.call(to:, from:, body:, status_callback: nil, request_id: nil, time: nil, reply_stream_name: nil, previous_message: nil)
        instance = self.build
        instance.(
          to: to,
          from: from,
          body: body,
          request_id: request_id,
          time: time,
          status_callback: status_callback,
          reply_stream_name: reply_stream_name,
          previous_message: previous_message
        )
      end

      def call(to:, from:, body:, status_callback: nil, request_id: nil, time: nil, reply_stream_name: nil, previous_message: nil)
        request_id ||= Identifier::UUID::Random.get
        time ||= Clock::UTC.iso8601

        sms_send = self.class.build_message(Messages::Commands::SmsSend, previous_message)

        sms_send.request_id = request_id
        sms_send.time = time
        sms_send.to = to
        sms_send.from = from
        sms_send.body = body
        sms_send.status_callback = status_callback

        stream_name = command_stream_name(request_id)

        write.(sms_send, stream_name, reply_stream_name: reply_stream_name)

        sms_send
      end
    end
  end
end
