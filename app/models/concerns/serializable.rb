module Serializable
  extend ActiveSupport::Concern

  class_methods do
    def serializer(klass = nil)
      @serializer ||= (klass || "#{self.name}Serializer".constantize)
    end    
  end
end
