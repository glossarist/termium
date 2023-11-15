# frozen_string_literal: true

module Termium
  # For <parameter>
  class Parameter < Shale::Mapper
    # <parameter abbreviation="NORM"/>
    attribute :abbreviation, Shale::Type::String
    xml do
      root "parameter"
      map_attribute "abbreviation", to: :abbreviation
    end
  end
end
