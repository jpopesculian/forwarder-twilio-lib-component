module TwilioLibComponent
  module Messages
    module Replies
      class RecordSmsFetchRejected
        include Messaging::Message

        attribute :request_id, String
        attribute :message_sid, String
        attribute :time, String
        attribute :error_message, String
        attribute :start_time, String
        attribute :processed_time, String
      end
    end
  end
end
