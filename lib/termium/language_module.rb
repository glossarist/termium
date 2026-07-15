# frozen_string_literal: true

module Termium
  # For <languageModule>
  class LanguageModule < Lutaml::Model::Serializable
    attribute :language, :string
    attribute :entry_term, EntryTerm, collection: true
    attribute :textual_support, TextualSupport, collection: true

    xml do
      element "languageModule"
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
      entry_term + abbreviations
    end

    def to_h
      # TODO: This is needed to skip the empty french entries of 10031781 and 10031778
      value = definition
      return nil unless value

      src = {
        "language_code" => LANGUAGE_CODE_MAPPING[language.downcase],
        "terms" => designations.map(&:to_h),
        "definition" => detailed_definitions([value]),
        "notes" => detailed_definitions(notes),
        "examples" => detailed_definitions(examples),
        "entry_status" => "valid",
      }

      src["domain"] = domain if domain

      src
    end

    def to_concept(options = {})
      x = to_h
      return nil unless x

      # The flat hash belongs under "data": LocalizedConcept is data-backed, and
      # `.new` would silently discard every key that is not one of its own
      # attributes. `of_yaml` also routes "terms" through ConceptData.
      Glossarist::LocalizedConcept.of_yaml({ "data" => x }).tap do |concept|
        # Fill in register parameters
        if options[:date_accepted]
          # `date_accepted` is a read-only derived accessor on Concept; the
          # accepted date is set by way of `data.dates`.
          concept.data.dates = [
            Glossarist::ConceptDate.new(
              date: options[:date_accepted],
              type: "accepted",
            ),
          ]
        end
      end
    end

    private

    def detailed_definitions(values)
      values.map { |value| { "content" => value } }
    end
  end
end
