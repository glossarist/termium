# frozen_string_literal: true

module Termium
  # For <sourceRef>
  class SourceRef < Shale::Mapper
    attribute :order, Shale::Type::Integer
    xml do
      root "sourceRef"
      map_attribute "order", to: :order
    end
  end
end
