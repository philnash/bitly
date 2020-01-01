# frozen_string_literal: true

module Bitly
  module API
    module Base
      def self.included(mod)
        attr_reader :response

        def mod.attributes ; [] ; end
        def mod.time_attributes ; [] ; end
      end

      def assign_attributes(attributes)
        self.class.attributes.each do |attr|
          instance_variable_set("@#{attr}", attributes[attr.to_s]) if attributes[attr.to_s]
        end
        self.class.time_attributes.each do |attr|
          instance_variable_set("@#{attr}", Time.parse(attributes[attr.to_s])) if attributes[attr.to_s]
        end
      end
    end
  end
end