# frozen_string_literal: true

require 'glossarist'
require 'shale'
require 'shale/adapter/nokogiri'
Shale.xml_adapter = Shale::Adapter::Nokogiri

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
