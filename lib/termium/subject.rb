# frozen_string_literal: true

module Termium
  # For <subject>
  class Subject < Shale::Mapper
    attribute :abbreviation, Shale::Type::String
    attribute :details, Shale::Type::String

    # <subject abbreviation="YBB" details="Compartment - ISO/IEC JTC 1 Information Technology Vocabulary"/>
    xml do
      root "subject"
      map_attribute "abbreviation", to: :abbreviation
      map_attribute "details", to: :details
    end
  end
end
