# frozen_string_literal: true

module Termium
  # For <sourceRef>
  class SourceRef < Lutaml::Model::Serializable
    attribute :order, :integer
    xml do
      root "sourceRef"
      map_attribute "order", to: :order
    end
  end
end
