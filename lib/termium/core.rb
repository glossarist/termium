require_relative 'language_module'
require_relative 'subject'
require_relative 'universal_entry'
require_relative 'source'

module Termium

  class Core < Shale::Mapper
    attribute :identification_number, Shale::Type::String
    attribute :dissemination_level, Shale::Type::String

    attribute :language_module, LanguageModule, collection: true
    attribute :subject, Subject
    attribute :universal_entry, UniversalEntry
    attribute :source, Source, collection: true

    xml do
      root 'core'
      map_attribute 'disseminationLevel', to: :dissemination_level
      map_attribute 'identificationNumber', to: :identification_number
      map_element 'languageModule', to: :language_module
      map_element 'subject', to: :subject
      map_element 'universalEntry', to: :universal_entry
      map_element 'source', to: :source
    end

    # TODO: In Termium XML, each definition per lang or note can be linked to a
    # particular source via the sourceRef number.
    def concept_sources
      source.map(&:to_concept_source)
    end

    def to_concept
      concept = Glossarist::ManagedConcept.new(id: identification_number)

      language_module.map(&:to_concept).each do |localized_concept|
        # TODO: This is needed to skip the empty french entries of 10031781 and 10031778
        next if localized_concept.nil?

        localized_concept.id = identification_number
        # TODO: this should just be localized_concept.notes << universal_entry.value
        # TODO: Depends on https://github.com/glossarist/glossarist-ruby/issues/82
        localized_concept.notes << Glossarist::DetailedDefinition.new(universal_entry.value)
        localized_concept.sources = concept_sources
        concept.add_localization(localized_concept)
      end

      concept
    end

  end
end