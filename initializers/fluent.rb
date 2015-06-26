require 'fluent-logger'

FLUENT = Fluent::Logger::FluentLogger.open(nil, :host=>'localhost', :port=>24224)

