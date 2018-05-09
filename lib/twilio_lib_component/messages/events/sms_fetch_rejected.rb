module TwilioLibComponent
  module Messages
    module Events
      class SmsFetchRejected
        include Messaging::Message

        attribute :request_id, String
        attribute :message_sid, String
        attribute :time, String
        attribute :error_message, String
        attribute :processed_time, String
        attribute :meta_position, Integer
      end
    end
  end
end
