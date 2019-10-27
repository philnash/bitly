# frozen_string_literal: true

module Bitly
  module API
    module Base
      def self.included(mod)
        attr_accessor :response
      end
    end
  end
end