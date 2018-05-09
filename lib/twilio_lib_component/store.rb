module TwilioLibComponent
  class Store
    include EntityStore

    category :twilio_lib
    entity Request
    projection Projection
    reader MessageStore::Postgres::Read
  end
end
