module TwilioLibComponent
  module Messages
    module Commands
      class SmsFetchInitiate
        include Messaging::Message

        attribute :request_id, String
        attribute :message_sid, String
        attribute :time, String
      end
    end
  end
end
