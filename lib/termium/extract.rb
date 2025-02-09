# frozen_string_literal: true

require_relative "extract_language"
require_relative "core"

module Termium
  # For <extract>
  class Extract < Lutaml::Model::Serializable
    attribute :language, :string
    attribute :extract_language, ExtractLanguage, collection: true
    attribute :core, Core, collection: true

    xml do
      root "termium_extract"
      # namespace "http://termium.tpsgc-pwgsc.gc.ca/schemas/2012/06/Termium", "ns2"

      map_attribute "language", to: :language
      map_element "extractLanguage", to: :extract_language
      map_element "core", to: :core
    end

    # xml do
    #   root "termium_extract"
    #   namespace "http://termium.tpsgc-pwgsc.gc.ca/schemas/2012/06/Termium", "ns2"

    #   map_attribute "language", to: :language, namespace: nil
    #   map_element "extractLanguage", to: :extract_language, namespace: nil
    #   map_element "core", to: :core, namespace: nil
    # end

    def to_concept(options = {})
      coll = Glossarist::ManagedConceptCollection.new
      coll.managed_concepts = core.map do |managed_concept|
        managed_concept.to_concept(options)
      end
      coll
    end
  end
end
