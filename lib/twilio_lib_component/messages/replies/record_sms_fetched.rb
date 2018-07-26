module TwilioLibComponent
  module Messages
    module Replies
      class RecordSmsFetched
        include Messaging::Message

        attribute :request_id, String
        attribute :message_sid, String
        attribute :time, String
        attribute :from, String
        attribute :to, String
        attribute :body, String
        attribute :direction, String
        attribute :status, String
        attribute :start_time, String
        attribute :processed_time, String
      end
    end
  end
end
