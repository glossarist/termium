# frozen_string_literal: true

RSpec.describe Termium::Extract do
  context "with ISO-IEC_2382.xml" do
    let(:fixture) { file_fixture("ISO-IEC_2382.xml") }
    it_behaves_like "a serializer"
  end

  context "with Characters.xml" do
    let(:fixture) { file_fixture("Characters.xml") }
    it_behaves_like "a serializer"
  end

  context "with Figures.xml" do
    let(:fixture) { file_fixture("Figures.xml") }
    it_behaves_like "a serializer"
  end
end
