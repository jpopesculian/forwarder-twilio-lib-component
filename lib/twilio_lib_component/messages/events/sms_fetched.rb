module TwilioLibComponent
  module Messages
    module Events
      class SmsFetched
        include Messaging::Message

        attribute :request_id, String
        attribute :message_sid, String
        attribute :time, String
        attribute :from, String
        attribute :to, String
        attribute :body, String
        attribute :direction, String
        attribute :status, String
        attribute :processed_time, String
        attribute :meta_position, Integer
      end
    end
  end
end
