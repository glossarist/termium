# frozen_string_literal: true

RSpec.shared_examples "a serializer" do
  it "round-trips" do
    input = fixture.read.gsub("> ", "&gt; ")

    serialized = described_class.from_xml(input)
    output = serialized.to_xml(
      prefix: true,
      declaration: true,
      encoding: "utf-8",
    )

    expect(output).to be_xml_equivalent_to(input)
  end
end
