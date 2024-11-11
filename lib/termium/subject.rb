# frozen_string_literal: true

module Termium
  # For <subject>
  class Subject < Lutaml::Model::Serializable
    attribute :abbreviation, :string
    attribute :details, :string

    # <subject abbreviation="YBB" details="Compartment - ISO/IEC JTC 1 Information Technology Vocabulary"/>
    xml do
      root "subject"
      map_attribute "abbreviation", to: :abbreviation
      map_attribute "details", to: :details
    end
  end
end
