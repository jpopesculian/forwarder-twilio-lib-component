module TwilioLibComponent
  module Utils
    class TwilioClient
      include Log::Dependency

      def self.configure(receiver, attr_name: nil)
        attr_name ||= :twilio_client
        instance = build
        receiver.public_send("#{attr_name}=", instance)
      end

      def self.build
        instance = new
        instance.configure
        instance
      end

      def configure
        settings = Settings.build 'settings/twilio_client.json'
        @client = Twilio::REST::Client.new(settings.get(:account_sid), settings.get(:auth_token))
      end

      def get_message(message_sid)
        logger.info(tag: :twilio_client) { "Fetching Message #{message_sid}" }
        client.messages(message_sid).fetch
      end

      def send_message(to:, from:, body:, status_callback:)
        logger.info(tag: :twilio_client) { "Sending Message To: #{to}, From: #{from}, Body: #{body}" }
        client.messages.create(
          to: to,
          from: from,
          body: body,
          status_callback: status_callback
        )
      end

      private

      attr_reader :client
    end
  end
end
