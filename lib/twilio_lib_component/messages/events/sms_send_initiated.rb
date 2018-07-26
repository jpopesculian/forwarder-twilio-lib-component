module TwilioLibComponent
  module Messages
    module Events
      class SmsSendInitiated
        include Messaging::Message

        attribute :request_id, String
        attribute :time, String
        attribute :to, String
        attribute :from, String
        attribute :body, String
        attribute :processed_time, String
        attribute :status_callback, String
      end
    end
  end
end
