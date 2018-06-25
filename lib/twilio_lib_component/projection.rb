module TwilioLibComponent
  class Projection
    include EntityProjection
    include Messages::Events

    entity_name :request

    apply SmsFetched do |sms_fetched|
      request.id = sms_fetched.request_id
      request.twilio_id = sms_fetched.message_sid
      request.to = sms_fetched.to
      request.from = sms_fetched.from
      request.body = sms_fetched.body
      request.finish_time = Time.parse(sms_fetched.processed_time)
      request.meta_position = sms_fetched.meta_position
    end

    apply SmsFetchRejected do |sms_fetch_rejected|
      request.id = sms_fetch_rejected.request_id
      request.twilio_id = sms_fetch_rejected.message_sid
      request.error = sms_fetch_rejected.error_message
      request.finish_time = Time.parse(sms_fetch_rejected.processed_time)
      request.meta_position = sms_fetch_rejected.meta_position
    end

    apply SmsFetchInitiated do |sms_fetch_initiated|
      request.id = sms_fetch_initiated.request_id
      request.twilio_id = sms_fetch_initiated.message_sid
      request.start_time = Time.parse(sms_fetch_initiated.processed_time)
    end

    apply SmsSent do |sms_sent|
      request.id = sms_sent.request_id
      request.twilio_id = sms_sent.message_sid
      request.to = sms_sent.to
      request.from = sms_sent.from
      request.body = sms_sent.body
      request.finish_time = Time.parse(sms_sent.processed_time)
      request.meta_position = sms_sent.meta_position
    end

    apply SmsSendRejected do |sms_send_rejected|
      request.id = sms_send_rejected.request_id
      request.error = sms_send_rejected.error_message
      request.finish_time = Time.parse(sms_send_rejected.processed_time)
      request.meta_position = sms_send_rejected.meta_position
    end

    apply SmsSendInitiated do |sms_send_initiated|
      request.id = sms_send_initiated.request_id
      request.start_time = Time.parse(sms_send_initiated.processed_time)
    end
  end
end
