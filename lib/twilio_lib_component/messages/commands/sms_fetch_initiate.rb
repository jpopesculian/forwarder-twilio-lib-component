module TwilioLibComponent
  module Messages
    module Commands
      class SmsFetchInitiate
        include Messaging::Message

        attribute :fetch_id, String
        attribute :message_sid, String
        attribute :time, String
        attribute :start_time, String
      end
    end
  end
end
