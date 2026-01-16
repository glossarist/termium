# frozen_string_literal: true

require_relative "entry_term"
require_relative "textual_support"

module Termium
  # For <languageModule>
  class LanguageModule < Lutaml::Model::Serializable
    attribute :language, :string
    attribute :entry_term, EntryTerm, collection: true
    attribute :textual_support, TextualSupport, collection: true
    xml do
      root "languageModule"
      map_attribute "language", to: :language
      map_element "entryTerm", to: :entry_term
      map_element "textualSupport", to: :textual_support
    end

    def definition_raw
      textual_support.detect(&:is_definition?)
    end

    def definition
      definition_raw&.value_typed
    end

    def domain
      definition_raw&.domain
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
      "fr" => "fre",
    }.freeze

    def designations
      # NOTE: entry_term is a collection
      (entry_term + abbreviations).compact
    end

    def to_h
      # TODO: This is needed to skip the empty french entries of 10031781 and 10031778
      return nil unless definition

      src = {
        "language_code" => LANGUAGE_CODE_MAPPING[language.downcase],
        "terms" => designations.map(&:to_h),
        "definition" => [{ content: definition }],
        "notes" => notes,
        "examples" => examples,
        "entry_status" => "valid",
      }

      src["domain"] = domain if domain

      src
    end

    def to_concept(options = {})
      return nil unless definition

      Glossarist::LocalizedConcept.new.tap do |concept|
        concept.data = Glossarist::ConceptData.new(
          language_code: LANGUAGE_CODE_MAPPING[language.downcase],
          terms: designations.map(&:to_designation),
          definition: [Glossarist::DetailedDefinition.new(content: definition)],
          notes: notes.map { |n| Glossarist::DetailedDefinition.new(content: n) },
          examples: examples.map { |e| Glossarist::DetailedDefinition.new(content: e) },
          entry_status: "valid",
          domain: domain
        )

        if options[:date_accepted]
          concept.date_accepted = options[:date_accepted]
        end
      end
    end
  end
end
