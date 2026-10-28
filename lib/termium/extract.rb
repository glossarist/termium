# frozen_string_literal: true

module Termium
  # For <extract>
  class Extract < Lutaml::Model::Serializable
    attribute :language, :string
    attribute :extract_language, ExtractLanguage, collection: true
    attribute :core, Core, collection: true

    xml do
      element "termium_extract"
      ordered
      namespace Namespace

      map_attribute "language", to: :language
      map_element "extractLanguage", to: :extract_language
      map_element "core", to: :core
    end

    def to_concept(options = {})
      coll = Glossarist::ManagedConceptCollection.new
      coll.managed_concepts = core.map do |managed_concept|
        managed_concept.to_concept(options)
      end
      coll
    end
  end
end
