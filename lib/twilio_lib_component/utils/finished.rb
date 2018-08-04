module TwilioLibComponent
  module Utils
    class Finished
      include Messaging::StreamName
      include Messages::Events

      category :twilio_lib

      dependency :write, Messaging::Postgres::Write

      def self.configure(receiver, attr_name: nil)
        attr_name ||= :finished
        instance = build
        receiver.public_send("#{attr_name}=", instance)
      end

      def self.build
        instance = new
        instance.configure
        instance
      end

      def configure
        Messaging::Postgres::Write.configure(self)
      end

      def call(message)
        request_id = message.request_id
        stream_name = stream_name(request_id)
        position = message.metadata.global_position

        request_finished = RequestFinished.follow(message, copy: [:request_id])
        request_finished.meta_position = position
        write.(request_finished, stream_name)
      end
    end
  end
end

