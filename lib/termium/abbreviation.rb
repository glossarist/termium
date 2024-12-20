# frozen_string_literal: true

require_relative "source_ref"
require_relative "parameter"
require_relative "designation_operations"

module Termium
  # For <abbreviation>
  class Abbreviation < Lutaml::Model::Serializable
    attribute :order, :integer
    attribute :value, :string
    attribute :source_ref, SourceRef
    attribute :parameter, Parameter, collection: true
    include DesignationOperations

    # <abbreviation order="1" value="PCI">
    # <sourceRef order="1" />
    # <parameter abbreviation="COR" />
    # <parameter abbreviation="F" />
    # <parameter abbreviation="NORM" />

    xml do
      root "abbreviation"
      map_attribute "order", to: :order
      map_attribute "value", to: :value
      map_element "sourceRef", to: :source_ref
      map_element "parameter", to: :parameter
    end

    def deprecated
      parameter.map(&:abbreviation).include?("AE")
    end

    def to_h
      set = {
        "designation" => value,
        "type" => "abbreviation",
        "normative_status" => deprecated ? "deprecated" : "preferred",
      }

      # if geographical_area
      #   set["geographical_area"] = geographical_area
      # end

      # if plurality
      #   set["plurality"] = plurality
      # end

      set["gender"] = gender if gender

      set["part_of_speech"] = part_of_speech if part_of_speech

      set
    end
  end
end
