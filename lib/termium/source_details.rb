# frozen_string_literal: true

module Termium
  # Parses the asterisk-delimited source details string
  class SourceDetails
    attr_accessor :raw, :author_name, :year, :organization, :department, :office, :division, :role

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
      @author_name = presence(columns[0])
      @year = presence(columns[1])
      @organization = presence(columns[2])
      @department = presence(columns[3])
      @office = presence(columns[4])
      @division = presence(columns[5])
      @role = presence(columns[6])
    end

    def presence(value)
      value unless value.nil? || value.empty?
    end

    alias to_xml raw
    alias to_s raw
  end
end
