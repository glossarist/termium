# frozen_string_literal: true

require_relative "source_details"

module Termium
  # For <source>
  class Source < Lutaml::Model::Serializable
    ISO_BIB_REGEX = /\AISO-([\d-]+)\s+\*\s+(\d{4})\s+.*/.freeze
    ISOIEC_BIB_REGEX = /\AISO-IEC-([\d-]+)\s+\*\s+(\d{4})\s+.*/.freeze

    attribute :order, :integer
    attribute :details, SourceDetails

    xml do
      root "source"
      map_attribute "order", to: :order
      map_attribute "details", to: :details
    end

    def content
      presentable_details = details.to_s
      if (matches = presentable_details.match(ISOIEC_BIB_REGEX))
        "ISO/IEC #{matches[1]}:#{matches[2]}"
      elsif (matches = presentable_details.match(ISO_BIB_REGEX))
        "ISO #{matches[1]}:#{matches[2]}"
      else
        presentable_details
      end
    end

    def to_concept_source
      Glossarist::ConceptSource.new({
                                      "type" => "lineage",
                                      "ref" => content,
                                      "status" => "identical",
                                    })
    end
  end
end
