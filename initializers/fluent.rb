require 'fluent-logger'
FLUENT = Fluent::Logger::FluentLogger.open(nil, :host=>'10.254.212.149', :port=>24224)

