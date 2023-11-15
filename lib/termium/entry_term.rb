require_relative 'source_ref'
require_relative 'abbreviation'
require_relative 'parameter'
require_relative 'designation_operations'

module Termium
  class EntryTerm < Shale::Mapper
    attribute :order, Shale::Type::Integer
    attribute :value, Shale::Type::String
    attribute :source_ref, SourceRef
    attribute :abbreviation, Abbreviation, collection: true
    attribute :parameter, Parameter, collection: true
    include DesignationOperations

    xml do
      root 'entryTerm'
      map_attribute 'order', to: :order
      map_attribute 'value', to: :value
      map_element 'abbreviation', to: :abbreviation
      map_element 'sourceRef', to: :source_ref
      map_element 'parameter', to: :parameter
    end

    # attr_accessor :geographical_area,
    #   :deprecated,
    #   :plurality,
    #   :part_of_speech,
    #   :gender

    GEOGRAPHICAL_CODE_MAPPING = {
      "USA" => "US",
      "CAN" => "CA",
      "GB" => "GB",
      "AUS" => "AU",
      "EUR" => "EU"
    }
    def geographical_area
      keys = GEOGRAPHICAL_CODE_MAPPING.keys
      usage = parameter.select do |x|
        keys.include?(x.abbreviation)
      end

      return nil if usage.empty?

      usage.map do |x|
        GEOGRAPHICAL_CODE_MAPPING[x.abbreviation]
      end.join("; ")
    end

    def deprecated
      parameter.map(&:abbreviation).include?("AE")
    end

    def plurality
      parameter.map(&:abbreviation).include?("PL") ?
        "plural" :
        "singular"
    end

    def to_h
      set = {
        "designation" => value,
        "type" => "expression",
        "normative_status" => deprecated ? "deprecated" : "preferred"
      }

      if geographical_area
        set["geographical_area"] = geographical_area
      end

      if plurality
        set["plurality"] = plurality
      end

      if gender
        set["gender"] = gender
      end

      if part_of_speech
        set["part_of_speech"] = part_of_speech
      end

      set
    end
  end
end