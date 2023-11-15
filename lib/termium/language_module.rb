require_relative 'entry_term'
require_relative 'textual_support'

module Termium

  class LanguageModule < Shale::Mapper
    attribute :language, Shale::Type::String
    attribute :entry_term, EntryTerm, collection: true
    attribute :textual_support, TextualSupport, collection:true
    xml do
      root 'languageModule'
      map_attribute 'language', to: :language
      map_element 'entryTerm', to: :entry_term
      map_element 'textualSupport', to: :textual_support
    end

    def definition_raw
      textual_support.detect(&:is_definition?)
    end

    def definition
      definition_raw ? definition_raw.value_typed : nil
    end

    def domain
      definition_raw ? definition_raw.domain : nil
    end

    def notes
      textual_support.select(&:is_note?).map(&:value_typed)
    end

    def examples
      textual_support.select(&:is_example?).map(&:value_typed)
    end

    def abbreviations
      entry_term.map(&:abbreviation).flatten
    end

    LANGUAGE_CODE_MAPPING = {
      "en" => "eng",
      "fr" => "fre"
    }

    def designations
      # NOTE: entry_term is a collection
      entry_term + abbreviations
    end

    def to_h
      lang_code = LANGUAGE_CODE_MAPPING[language.downcase]

      # TODO: This is needed to skip the empty french entries of 10031781 and 10031778
      return nil unless definition

      src = {
        "language_code" => lang_code,
        "terms" => designations.map(&:to_h),
        "definition" => [{
          content: definition
        }],
        "notes" => notes,
        "examples" => examples,
      }

      if domain
        src["domain"] = domain
      end

      src
    end

    def to_concept
      x = to_h
      return nil unless x
      Glossarist::LocalizedConcept.new(x)
    end
  end
end