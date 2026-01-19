# frozen_string_literal: true

RSpec.describe Termium::Source do
  describe "XML round-trip" do
    let(:xml_input) { '<source order="1" details="ISO-IEC-2382-16 * 1996 *  *  * "/>' }

    it "preserves details attribute" do
      source = described_class.from_xml(xml_input)
      output = source.to_xml

      expect(output).to include('details="ISO-IEC-2382-16 * 1996 *  *  * "')
    end

    it "parses details into SourceDetails object" do
      source = described_class.from_xml(xml_input)

      expect(source.details).to be_a(Termium::SourceDetails)
      expect(source.details.standard).to eq("ISO-IEC-2382-16")
    end
  end

  describe "#content" do
    context "with ISO-IEC standard" do
      let(:source) { described_class.from_xml('<source order="1" details="ISO-IEC-2382-16 * 1996 *  *  * "/>') }

      it "formats as ISO/IEC reference" do
        expect(source.content).to eq("ISO/IEC 2382-16:1996")
      end
    end

    context "with ISO standard" do
      let(:source) { described_class.from_xml('<source order="1" details="ISO-2382-12 * 1988 *  *  * "/>') }

      it "formats as ISO reference" do
        expect(source.content).to eq("ISO 2382-12:1988")
      end
    end

    context "with non-standard source" do
      let(:source) { described_class.from_xml('<source order="1" details="Ranger, Natalie * 2006 * Bureau de la traduction"/>') }

      it "returns raw details" do
        expect(source.content).to eq("Ranger, Natalie * 2006 * Bureau de la traduction")
      end
    end
  end
end
