module TwilioLibComponent
  module Handlers
    class Events
      include Log::Dependency
      include Messaging::Handle
      include Messaging::StreamName

      include Messages::Events
      include Messages::Replies

      dependency :write, Messaging::Postgres::Write
      dependency :clock, Clock::UTC
      dependency :twilio_client, TwilioLibComponent::Utils::TwilioClient
      dependency :store, Store
      dependency :processed, Utils::Processed
      dependency :finished, Utils::Finished

      def configure
        Messaging::Postgres::Write.configure(self)
        Clock::UTC.configure(self)
        TwilioLibComponent::Utils::TwilioClient.configure(self)
        Store.configure(self)
        Utils::Processed.configure(self)
        Utils::Finished.configure(self)
      end

      category :twilio_lib

      handle SmsFetchInitiated do |sms_fetch_initiated|
        request_id = sms_fetch_initiated.request_id
        message_sid = sms_fetch_initiated.message_sid
        position = sms_fetch_initiated.metadata.global_position

        current, ignored = processed.(sms_fetch_initiated)
        return ignored.() if current

        request = store.fetch(request_id)
        if request.finished?
          logger.info(tag: :ignored) { "Event ignored (Event: #{sms_fetch_initiated.message_type}, Request ID: #{request_id}, Message SID: #{sms_fetch_initiated.request_id}" }
          return
        end

        stream_name = stream_name(request_id, 'twilioLib')

        begin
          message = twilio_client.get_message(message_sid)

          time = clock.iso8601

          sms_fetched = SmsFetched.follow(sms_fetch_initiated)
          sms_fetched.to = message.to
          sms_fetched.from = message.from
          sms_fetched.body = message.body
          sms_fetched.time = message.date_sent.iso8601
          sms_fetched.direction = message.direction
          sms_fetched.status = message.status
          sms_fetched.processed_time = time
          sms_fetched.meta_position = position

          write.(sms_fetched, stream_name)
        rescue Twilio::REST::TwilioError => error
          time = clock.iso8601

          sms_fetch_rejected = SmsFetchRejected.follow(sms_fetch_initiated)
          sms_fetch_rejected.error_message = error.message
          sms_fetch_rejected.processed_time = time
          sms_fetch_rejected.meta_position = position

          write.(sms_fetch_rejected, stream_name)
        end
      end

      handle SmsSendInitiated do |sms_send_initiated|
        request_id = sms_send_initiated.request_id
        position = sms_send_initiated.metadata.global_position

        current, ignored = processed.(sms_send_initiated)
        return ignored.() if current

        request = store.fetch(request_id)
        if request.finished?
          logger.info(tag: :ignored) { "Event ignored (Event: #{sms_send_initiated.message_type}, Request ID: #{request_id}, Message SID: #{sms_send_initiated.request_id}" }
          return
        end

        stream_name = stream_name(request_id, 'twilioLib')

        begin
          message = twilio_client.send_message(
            to: sms_send_initiated.to,
            from: sms_send_initiated.from,
            body: sms_send_initiated.body,
            status_callback: sms_send_initiated.status_callback
          )

          time = clock.iso8601

          sms_sent = SmsSent.follow(sms_send_initiated)
          sms_sent.message_sid = message.sid
          sms_sent.to = message.to
          sms_sent.from = message.from
          sms_sent.body = message.body
          sms_sent.processed_time = time
          sms_sent.meta_position = position

          write.(sms_sent, stream_name)
        rescue Twilio::REST::TwilioError => error
          time = clock.iso8601

          sms_send_rejected = SmsSendRejected.follow(sms_send_initiated)
          sms_send_rejected.error_message = error.message
          sms_send_rejected.processed_time = time
          sms_send_rejected.meta_position = position

          write.(sms_send_rejected, stream_name)
        end
      end

      handle SmsFetched do |sms_fetched|
        return unless sms_fetched.metadata.reply?

        current, ignored = processed.(sms_fetched)
        return ignored.() if current

        record_sms_fetched = RecordSmsFetched.follow(sms_fetched, exclude: [
          :meta_position
        ])

        write.reply(record_sms_fetched)
        finished.(sms_fetched)
      end

      handle SmsFetchRejected do |sms_fetch_rejected|
        return unless sms_fetch_rejected.metadata.reply?

        current, ignored = processed.(sms_fetch_rejected)
        return ignored.() if current

        record_sms_fetch_rejected = RecordSmsFetchRejected.follow(sms_fetch_rejected, exclude: [
          :meta_position
        ])

        write.reply(record_sms_fetch_rejected)
        finished.(sms_fetch_rejected)
      end

      handle SmsSent do |sms_sent|
        return unless sms_sent.metadata.reply?

        current, ignored = processed.(sms_sent)
        return ignored.() if current

        record_sms_sent = RecordSmsSent.follow(sms_sent, exclude: [
          :meta_position
        ])

        write.reply(record_sms_sent)
        finished.(sms_sent)
      end

      handle SmsSendRejected do |sms_send_rejected|
        return unless sms_send_rejected.metadata.reply?

        current, ignored = processed.(sms_send_rejected)
        return ignored.() if current

        record_sms_send_rejected = RecordSmsSendRejected.follow(sms_send_rejected, exclude: [
          :meta_position
        ])

        write.reply(record_sms_send_rejected)
        finished.(sms_send_rejected)
      end
    end
  end
end
