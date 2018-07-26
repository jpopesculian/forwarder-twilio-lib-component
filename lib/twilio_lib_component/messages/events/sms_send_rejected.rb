module TwilioLibComponent
  module Messages
    module Events
      class SmsSendRejected
        include Messaging::Message

        attribute :request_id, String
        attribute :to, String
        attribute :from, String
        attribute :body, String
        attribute :time, String
        attribute :error_message, String
        attribute :processed_time, String
        attribute :meta_position, Integer
        attribute :status_callback, String
      end
    end
  end
end
