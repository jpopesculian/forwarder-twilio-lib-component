module TwilioLibComponent
  class Request
    include Schema::DataStructure

    attribute :id, String
    attribute :twilio_id, String
    attribute :to, String
    attribute :from, String
    attribute :body, String
    attribute :error, String
    attribute :start_time, Time
    attribute :finish_time, Time
    attribute :meta_position, Integer

    def started?
      !start_time.nil?
    end

    def finished?
      !finish_time.nil?
    end

    def current?(position)
      return false if meta_position.nil?
      meta_position >= position
    end
  end
end
