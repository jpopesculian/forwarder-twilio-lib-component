ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= 'info'
ENV['LOG_TAGS'] ||= '_untagged,-data,messaging,entity_projection,entity_store,ignored'

puts RUBY_DESCRIPTION

require_relative '../init.rb'
require 'pry-byebug'

require 'pp'

module TwilioLibComponent; end
include TwilioLibComponent
