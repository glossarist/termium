# frozen_string_literal: true

require_relative "source_ref"
require_relative "parameter"

module Termium
  # For <universalEntry>
  class UniversalEntry < Lutaml::Model::Serializable
    attribute :order, :integer
    attribute :value, :string
    attribute :source_ref, SourceRef
    attribute :parameter, Parameter

    # <universalEntry order="1">
    #   <value>09.08.09 (2382)</value>
    #   <sourceRef order="1"/>
    #   <parameter abbreviation="CONUM"/>
    # </universalEntry>

    xml do
      root "universalEntry"
      map_attribute "order", to: :order
      map_element "value", to: :value
      map_element "sourceRef", to: :source_ref
      map_element "parameter", to: :parameter
    end
  end
end
