require_relative 'source_ref'

module Termium

  class TextualSupport < Shale::Mapper
    attribute :order, Shale::Type::Integer
    attribute :type, Shale::Type::String
    attribute :value, Shale::Type::String
    attribute :source_ref, SourceRef
    xml do
      root 'textualSupport'
      map_attribute 'order', to: :order
      map_attribute 'type', to: :type
      map_element 'value', to: :value
      map_element 'sourceRef', to: :source_ref
    end

    def value_cleaned
      value.gsub(/\n\s+/, " ")
    end

    def value_typed
      if is_example?
        value_example
      elsif is_definition?
        value_definition
      else
        value_cleaned
      end
    end

    EXAMPLE_REGEX = /\AEx[ea]mples?\s*:\s*/
    def is_example?
      value_cleaned.match(EXAMPLE_REGEX)
    end

    def is_definition?
      type == "DEF"
    end

    def is_note?
      !is_definition? && !is_example?
    end

    def value_example
      value_cleaned.gsub(EXAMPLE_REGEX, '')
    end

    DEFINITION_REGEX = /\A\<(.+?)\>\s*/
    def value_definition
      value_cleaned.gsub(DEFINITION_REGEX, '')
    end

    def has_domain?
      !value_cleaned.match(DEFINITION_REGEX).nil?
    end

    def domain
      if has_domain?
        value_cleaned.match(DEFINITION_REGEX)[1]
      end
    end

    # This is an attempt to extract the textual reference within the note.
    # TODO: Use this to correlate the actual term with the source reference, i.e
    # from the following note, the terms "abduction; inférence abductive" come from
    # "ISO-IEC-2382-28-1995".
    # NOTE:  abduction; inférence abductive : termes et définition normalisés par l'ISO/CEI [<<ISO-IEC-2382-28-1995>>].
    def source_from_note
      x = note.match(/\[.*\]/)
      return nil if x.nil?

      ref = x.match(/\[.*\]/).to_s.gsub(/[\[\]]/, '')

      # "[ISO/IEC 2382-13:1996; ISO/IEC 2382-24:1995]"
      refs = if ref.include?(";")
        ref.split("; ")
      else
        [ref]
      end
    end
  end
end