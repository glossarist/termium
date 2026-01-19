# frozen_string_literal: true

RSpec.describe Termium::SourceDetails do
  describe ".cast" do
    context "with ISO standard (no organization)" do
      let(:input) { "ISO-IEC-2382-16 * 1996 *  *  * " }
      subject(:details) { described_class.cast(input) }

      it "sets standard from first column" do
        expect(details.standard).to eq("ISO-IEC-2382-16")
      end

      it "sets year" do
        expect(details.year).to eq("1996")
      end

      it "does not set author_name" do
        expect(details.author_name).to be_nil
      end

      it "does not set organization" do
        expect(details.organization).to be_nil
      end
    end

    context "with personal author (has organization)" do
      let(:input) { "Ranger, Natalie * 2006 * Bureau de la traduction * Services linguistiques" }
      subject(:details) { described_class.cast(input) }

      it "sets author_name from first column" do
        expect(details.author_name).to eq("Ranger, Natalie")
      end

      it "sets year" do
        expect(details.year).to eq("2006")
      end

      it "sets organization" do
        expect(details.organization).to eq("Bureau de la traduction")
      end

      it "sets department" do
        expect(details.department).to eq("Services linguistiques")
      end

      it "does not set standard" do
        expect(details.standard).to be_nil
      end
    end

    context "when value is already SourceDetails" do
      let(:original) { described_class.cast("ISO-IEC-2382-16 * 1996 *  *  * ") }

      it "returns the same object" do
        expect(described_class.cast(original)).to be(original)
      end
    end

    context "with nil input" do
      it "returns nil" do
        expect(described_class.cast(nil)).to be_nil
      end
    end

    context "with empty string" do
      it "returns nil" do
        expect(described_class.cast("")).to be_nil
      end
    end
  end

  describe ".serialize" do
    let(:details) { described_class.cast("ISO-IEC-2382-16 * 1996 *  *  * ") }

    it "returns the raw string" do
      expect(described_class.serialize(details)).to eq("ISO-IEC-2382-16 * 1996 *  *  * ")
    end

    it "returns nil for nil input" do
      expect(described_class.serialize(nil)).to be_nil
    end
  end

  describe "#to_s" do
    let(:details) { described_class.cast("Ranger, Natalie * 2006 * Bureau de la traduction") }

    it "returns the raw string" do
      expect(details.to_s).to eq("Ranger, Natalie * 2006 * Bureau de la traduction")
    end
  end
end
