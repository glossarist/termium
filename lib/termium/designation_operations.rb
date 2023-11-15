module Termium

  module DesignationOperations
    PART_OF_SPEECH_CODE_MAPPING = {
      "ADJ" => "adj",
      "N" => "noun",
      "V" => "verb"
    }
    def part_of_speech
      value = parameter.detect do |x|
        PART_OF_SPEECH_CODE_MAPPING[x.abbreviation]
      end

      value ? PART_OF_SPEECH_CODE_MAPPING[value.abbreviation] : nil
    end

    GENDER_CODE_MAPPING = {
      "F" => "f",
      "M" => "m",
      "EPI" => "c" # this means "Epicine"
    }
    def gender
      value = parameter.detect do |x|
        GENDER_CODE_MAPPING[x.abbreviation]
      end

      value ? GENDER_CODE_MAPPING[value.abbreviation] : nil
    end
  end

end
