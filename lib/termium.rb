# frozen_string_literal: true

require "glossarist"

require "lutaml/model"
require "lutaml/model/xml_adapter/nokogiri_adapter"

Lutaml::Model::Config.configure do |config|
  config.xml_adapter = Lutaml::Model::XmlAdapter::NokogiriAdapter
end

module Termium
  class Error < StandardError; end
end

require_relative "termium/version"
require_relative "termium/extract"
require_relative "termium/extract_language"
require_relative "termium/core"
require_relative "termium/abbreviation"
require_relative "termium/designation_operations"
require_relative "termium/entry_term"
require_relative "termium/language_module"
require_relative "termium/parameter"
require_relative "termium/source"
require_relative "termium/source_ref"
require_relative "termium/subject"
require_relative "termium/textual_support"
require_relative "termium/universal_entry"
