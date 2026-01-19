# frozen_string_literal: true

module Termium
  # Parses the asterisk-delimited source details string
  class SourceDetails
    attr_accessor :raw, :standard, :author_name, :year, :organization, :department, :office, :division, :role

    class << self
      def cast(value)
        return value if value.is_a?(SourceDetails)
        return nil if value.nil? || value.to_s.strip.empty?

        new(
          value
        )
      end

      def serialize(value)
        value&.raw
      end

      alias from_xml cast
    end

    def initialize(value)
      return if value.nil? || value.to_s.strip.empty?

      columns = value.to_s.split("*").map(&:strip)

      @raw = value.to_s
      @year = presence(columns[1])
      @organization = presence(columns[2])
      @department = presence(columns[3])
      @office = presence(columns[4])
      @division = presence(columns[5])
      @role = presence(columns[6])

      first_column = presence(columns[0])
      if standard_identifier?(first_column)
        @standard = first_column
      else
        @author_name = first_column
      end
    end

    def presence(value)
      value unless value.nil? || value.empty?
    end

    # Matches ISO or ISO-IEC standard identifiers with a document number
    # e.g., "ISO-9000", "ISO-IEC-2382-16", "ISO-IEC-27001"
    def standard_identifier?(value)
      return false if value.nil?

      value.match?(/\AISO(-IEC)?-\d+/i)
    end

    alias to_xml raw
    alias to_s raw
  end
end
