require_relative './client_exercise_init'

TwilioLibComponent::Start.()

message_sid = "SM167c72b00640f6f1885b34960e16c568_"

command = TwilioLib::Client::SmsFetch.(
    message_sid: message_sid,
)

# stream_name = "twilioLib-#{command.fetch_id}"

while true do
  sleep 1
end
