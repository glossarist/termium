module Termium

  class Source < Shale::Mapper
    ISO_BIB_REGEX = /\AISO-([\d-]+)\s+\*\s+(\d{4})\s+.*/
    ISOIEC_BIB_REGEX = /\AISO-IEC-([\d-]+)\s+\*\s+(\d{4})\s+.*/

    attribute :order, Shale::Type::Integer
    attribute :details, Shale::Type::String
    xml do
      root 'source'
      map_attribute 'order', to: :order
      map_attribute 'details', to: :details
    end

    def content
      if matches = details.match(ISOIEC_BIB_REGEX)
        return "ISO/IEC #{matches[1]}:#{matches[2]}"
      elsif matches = details.match(ISO_BIB_REGEX)
        return "ISO #{matches[1]}:#{matches[2]}"
      else
        details
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
