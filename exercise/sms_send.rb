require_relative './client_exercise_init'

TwilioLibComponent::Start.()

message_sid = "SM167c72b00640f6f1885b34960e16c568"

class SomeMessage
  include Messaging::Message
end

store = TwilioLibComponent::Store.build

some_message = SomeMessage.new
some_message.metadata.source_message_stream_name = 'someMessage-some_id'
some_message.metadata.source_message_position = 111

command = TwilioLib::Client::SmsSend.(
  to: '+19165854267',
  from: '+14158542955',
  body: 'hellllo',
  previous_message: some_message,
  reply_stream_name: 'someReplyStream'
)

# stream_name = "twilioLib-#{command.request_id}"

while true do
  # request = store.fetch(command.request_id)
  # puts "Request #{request.id}: From: #{request.from}, To: #{request.to}, Body: #{request.body}, Error: #{request.error}"
  # MessageStore::Postgres::Read.("twilioLib-#{command.request_id}") do |data|
  #   TwilioLibComponent::Handlers::Events.(data)
  # end
  # MessageStore::Postgres::Read.("twilioLibRest:command-#{command.request_id}") do |data|
  #   TwilioLibComponent::Handlers::Commands::Rest.(data)
  # end
  sleep 5
end
