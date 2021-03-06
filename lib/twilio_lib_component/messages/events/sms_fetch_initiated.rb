module TwilioLibComponent
  module Messages
    module Events
      class SmsFetchInitiated
        include Messaging::Message

        attribute :request_id, String
        attribute :message_sid, String
        attribute :time, String
        attribute :processed_time, String
      end
    end
  end
end
