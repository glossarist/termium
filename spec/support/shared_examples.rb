RSpec.shared_examples "a serializer" do
  xit "round-trips with equivalent-xml" do
    input = fixture.read.gsub("> ", "&gt; ")

    serialized = described_class.from_xml(input)
    output = serialized.to_xml(declaration: true, encoding: "utf-8")

    expect(output).to be_equivalent_to(input)
  end

  it "round-trips with xml-c14" do
    input = Xml::C14n.format(fixture.read.gsub("> ", "&gt; "))

    serialized = described_class.from_xml(input)
    output = Xml::C14n.format(serialized.to_xml)

    File.write("tmp/output.xml", output)
    File.write("tmp/input.xml", input)

    expect(output).to be_analogous_with(input)
  end
end
