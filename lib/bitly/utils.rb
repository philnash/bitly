module Bitly
  module Utils
    private
    def underscore(camel_cased_word) # stolen from rails
      camel_cased_word.to_s.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end
    
    def attr_define(k,v)
      instance_variable_set("@#{k}", v)
      meta = class << self; self; end
      meta.class_eval { attr_reader k.to_sym }
    end

    def instance_variablise(obj,variables)
      if obj.is_a? Hash
        obj.each do |k,v|
          if v.is_a? Hash
            instance_variablise(v)
          else
            attr_define(underscore(k),v) if variables.include?(underscore(k))
          end
        end
      end
    end
  end
end