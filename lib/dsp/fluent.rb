require 'uuidtools'
require 'fluent-logger'
require 'active_support/inflector' unless defined? Rails

module Dsp
	module Fluent
		def self.included(base)
	        base.extend(ClassMethods)
	    end
	    module ClassMethods
        # Returns the connection object to Fluent.
        def connection
          @connection || FLUENT
        end
        
        # Specify the connection object that this class should use. 
        def connect_using conn
          @connection = conn
        end

        # Specify the label string for Fluent.
        def label_as label
          @label = label
        end

        # Display the label being used for this class.
        def label
          @label ||= self.new.class.to_s.underscore.gsub('/', '.')
        end

        # Log to Fluent
        def << log_info
          # payload["uuid"] = UUIDTools::UUID.timestamp_create.to_i.to_s unless payload.has_key? "uuid"
          self.connection.post self.label, log_info
        end
      end
	end
	
end

