# frozen_string_literal: true

module Termium
  # For <source>
  class Source < Lutaml::Model::Serializable
    ISO_BIB_REGEX = /\AISO-([\d-]+)\s+\*\s+(\d{4})\s+.*/
    ISOIEC_BIB_REGEX = /\AISO-IEC-([\d-]+)\s+\*\s+(\d{4})\s+.*/

    attribute :order, :integer
    attribute :details, SourceDetails

    xml do
      element "source"
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

    # glossarist >= 2.14 has no `ref` on ConceptSource; the reference lives in
    # `origin`, a Citation.
    def to_concept_source
      Glossarist::ConceptSource.new(
        type: "lineage",
        status: "identical",
        origin: origin_citation,
      )
    end

    private

    def origin_citation
      if (matches = content.match(/\A(ISO(?:\/IEC)?) (.+)\z/))
        Glossarist::Citation.new(
          ref: Glossarist::Citation::Ref.new(source: matches[1],
                                             id: matches[2]),
        )
      else
        Glossarist::Citation.new(text: content)
      end
    end
  end
end
