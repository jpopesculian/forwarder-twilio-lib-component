module TwilioLibComponent
  module Consumers
    class Commands
      class Rest
        include Consumer::Postgres

        handler Handlers::Commands::Rest
      end
    end
  end
end
