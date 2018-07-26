module TwilioLibComponent
  module Messages
    module Commands
      class SmsSendInitiate
        include Messaging::Message

        attribute :request_id, String
        attribute :to, String
        attribute :from, String
        attribute :body, String
        attribute :time, String
        attribute :status_callback, String
      end
    end
  end
end
