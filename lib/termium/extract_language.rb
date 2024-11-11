# frozen_string_literal: true

module Termium
  # For <extractLanguage>
  class ExtractLanguage < Lutaml::Model::Serializable
    attribute :language, :string
    attribute :order, :integer
    xml do
      root "extractLanguage"
      map_attribute "language", to: :language
      map_attribute "order", to: :order
    end
  end
end
