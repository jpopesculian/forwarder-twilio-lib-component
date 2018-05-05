module TwilioLibComponent
  module Messages
    module Commands
      class SmsFetch
        include Messaging::Message

        attribute :fetch_id, String
        attribute :message_sid, String
        attribute :time, String
      end
    end
  end
end
