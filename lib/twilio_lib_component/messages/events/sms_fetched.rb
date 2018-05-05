module TwilioLibComponent
  module Messages
    module Events
      class SmsFetched
        include Messaging::Message

        attribute :fetch_id, String
        attribute :message_sid, String
        attribute :time, String
        attribute :from, String
        attribute :to, String
        attribute :body, String
        attribute :start_time, String
        attribute :processed_time, String
      end
    end
  end
end
