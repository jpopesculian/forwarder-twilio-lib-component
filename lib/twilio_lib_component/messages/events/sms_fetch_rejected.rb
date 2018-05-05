module TwilioLibComponent
  module Messages
    module Events
      class SmsFetchRejected
        include Messaging::Message

        attribute :fetch_id, String
        attribute :message_sid, String
        attribute :time, String
        attribute :error_message, String
        attribute :start_time, String
        attribute :processed_time, String
      end
    end
  end
end
