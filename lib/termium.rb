# frozen_string_literal: true

require "glossarist"

module Termium
  class Error < StandardError; end

  autoload :Version, "termium/version"
  autoload :Extract, "termium/extract"
  autoload :ExtractLanguage, "termium/extract_language"
  autoload :Core, "termium/core"
  autoload :Abbreviation, "termium/abbreviation"
  autoload :DesignationOperations, "termium/designation_operations"
  autoload :EntryTerm, "termium/entry_term"
  autoload :LanguageModule, "termium/language_module"
  autoload :Parameter, "termium/parameter"
  autoload :Namespace, "termium/namespace"
  autoload :Source, "termium/source"
  autoload :SourceRef, "termium/source_ref"
  autoload :Subject, "termium/subject"
  autoload :TextualSupport, "termium/textual_support"
  autoload :UniversalEntry, "termium/universal_entry"
end
