# frozen_string_literal: true

RSpec.describe Termium::Core do
  describe "#subject_field" do
    context "with subject" do
      let(:core) { described_class.new(subject: Termium::Subject.new(abbreviation: "YBB", details: "Compartment - ISO/IEC JTC 1")) }

      it "returns details with abbreviation" do
        expect(core.subject_field).to eq("Compartment - ISO/IEC JTC 1 (YBB)")
      end
    end

    context "without subject" do
      let(:core) { described_class.new }

      it "returns nil" do
        expect(core.subject_field).to be_nil
      end
    end
  end
end
