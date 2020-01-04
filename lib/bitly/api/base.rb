# frozen_string_literal: true

module Bitly
  module API
    module Base
      attr_reader :response

      def assign_attributes(attributes)
        if self.class.respond_to?(:attributes)
          self.class.attributes.each do |attr|
            instance_variable_set("@#{attr}", attributes[attr.to_s]) if attributes[attr.to_s]
          end
        end
        if self.class.respond_to?(:time_attributes)
          self.class.time_attributes.each do |attr|
            instance_variable_set("@#{attr}", Time.parse(attributes[attr.to_s])) if attributes[attr.to_s]
          end
        end
      end
    end
  end
end