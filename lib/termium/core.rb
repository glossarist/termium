# frozen_string_literal: true

require_relative "language_module"
require_relative "subject"
require_relative "universal_entry"
require_relative "source"

module Termium
  # For <core>
  class Core < Lutaml::Model::Serializable
    attribute :identification_number, :string
    attribute :dissemination_level, :string

    attribute :language_module, LanguageModule, collection: true
    attribute :subject, Subject
    attribute :universal_entry, UniversalEntry, collection: true
    attribute :source, Source, collection: true

    xml do
      root "core"
      map_attribute "disseminationLevel", to: :dissemination_level
      map_attribute "identificationNumber", to: :identification_number
      map_element "languageModule", to: :language_module
      map_element "subject", to: :subject
      map_element "universalEntry", to: :universal_entry
      map_element "source", to: :source
    end

    # TODO: In Termium XML, each definition per lang or note can be linked to a
    # particular source via the sourceRef number.
    # We should utilize "source" order ID in the Glossarist object:
    # <source order="1" details="ISO-2382-6 * 1987 *  *  * " />
    # <source order="2"
    #   details="Ranger, Natalie * 2006 * Bureau de la traduction..." />
    def concept_sources
      source.map(&:to_concept_source)
    end

    # TODO: Utilize "subject" in the Glossarist object:
    # <subject abbreviation="YBB"
    # details="Compartment - ISO/IEC JTC 1 Information Technology Vocabulary" />
    def to_concept
      concept = Glossarist::ManagedConcept.new(id: identification_number)

      language_module.map(&:to_concept).each do |localized_concept|
        # TODO: This is needed to skip the empty french entries of 10031781 and 10031778
        next if localized_concept.nil?

        localized_concept.id = identification_number
        universal_entry.each do |entry|
          localized_concept.notes << entry.value
        end
        localized_concept.sources = concept_sources
        concept.add_localization(localized_concept)
      end

      concept
    end
  end
end
