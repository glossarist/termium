module Termium
  class ExtractLanguage < Shale::Mapper
    attribute :language, Shale::Type::String
    attribute :order, Shale::Type::Integer
    xml do
      root 'extractLanguage'
      map_attribute 'language', to: :language
      map_attribute 'order', to: :order
    end
  end

end
