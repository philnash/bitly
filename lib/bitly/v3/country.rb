module Bitly
  module V3
    class Country
      attr_reader :clicks, :country
    
      def initialize(opts)
        ['clicks', 'country'].each do |attribute|
          instance_variable_set("@#{attribute}".to_sym, opts[attribute])
        end
      end
    end
  end
end