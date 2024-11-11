# frozen_string_literal: true

module Termium
  # For <parameter>
  class Parameter < Lutaml::Model::Serializable
    # <parameter abbreviation="NORM"/>
    attribute :abbreviation, :string
    xml do
      root "parameter"
      map_attribute "abbreviation", to: :abbreviation
    end
  end
end
