# frozen_string_literal: true

RSpec.describe Termium do
  it "has a version number" do
    expect(Termium::VERSION).not_to be nil
  end

  # let(:concept_folder) { "concept_collection_v2" }
  # let(:concept_files) { Dir.glob(File.join(fixtures_path(concept_folder), "concept", "*.{yaml,yml}")) }
  # let(:localized_concepts_folder) { File.join(fixtures_path(concept_folder), "localized_concept") }

  let(:termium_extract_file) { File.join(fixtures_path, "Characters.xml") }
  let(:glossarist_output_file) { File.join(fixtures_path, "Characters-Glossarist") }
  it "does something useful" do
    termium_extract = Termium::Extract.from_xml(IO.read(termium_extract_file))
    glossarist_col = termium_extract.to_concept
    FileUtils.mkdir_p(glossarist_output_file)
    glossarist_col.save_to_files(glossarist_output_file)
  end
end
