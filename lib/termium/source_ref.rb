module Termium
  class SourceRef < Shale::Mapper
    attribute :order, Shale::Type::Integer
    xml do
      root 'sourceRef'
      map_attribute 'order', to: :order
    end
  end
end