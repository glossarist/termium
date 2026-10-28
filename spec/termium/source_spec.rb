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

RSpec.describe Termium::Source, "#to_concept_source" do
  def origin_for(details)
    described_class.from_xml(%(<source order="1" details="#{details}"/>))
                   .to_concept_source.origin
  end

  it "carries the parsed ISO/IEC standard as the citation ref" do
    ref = origin_for("ISO-IEC-2382-16 * 1996 *  *  * ").ref

    expect([ref.source, ref.id]).to eq(["ISO/IEC", "2382-16:1996"])
  end

  it "carries the parsed ISO standard as the citation ref" do
    ref = origin_for("ISO-2382-12 * 1988 *  *  * ").ref

    expect([ref.source, ref.id]).to eq(["ISO", "2382-12:1988"])
  end

  it "keeps a non-standard source as citation text" do
    origin = origin_for("Ranger, Natalie * 2006 * Bureau de la traduction")

    expect(origin.text).to eq("Ranger, Natalie * 2006 * Bureau de la traduction")
  end
end
