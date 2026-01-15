# frozen_string_literal: true

require "yaml"

RSpec.describe Termium do
  let(:termium_extract_file) { fixtures_path("Characters.xml") }
  let(:glossarist_output_dir) { fixtures_path("Characters-Glossarist") }

  before do
    FileUtils.mkdir_p(glossarist_output_dir)
  end

  after do
    FileUtils.rm_rf(glossarist_output_dir)
  end

  describe "V2 format conversion" do
    let(:termium_extract) { Termium::Extract.from_xml(IO.read(termium_extract_file)) }
    let(:glossarist_col) { termium_extract.to_concept }

    before do
      glossarist_col.save_to_files(glossarist_output_dir)
    end

    it "creates concept and localized_concept directories" do
      expect(Dir.exist?(File.join(glossarist_output_dir, "concept"))).to be true
      expect(Dir.exist?(File.join(glossarist_output_dir, "localized_concept"))).to be true
    end

    it "creates concept files with V2 structure" do
      concept_files = Dir.glob(File.join(glossarist_output_dir, "concept", "*.yaml"))
      expect(concept_files).not_to be_empty

      concept_files.each do |file|
        concept = YAML.safe_load(File.read(file), permitted_classes: [Date, Time])

        # V2: concept must have id (UUID) at root level
        expect(concept).to have_key("id")
        expect(concept["id"]).to match(/^[0-9a-f-]{36}$/)

        # V2: concept must have data with identifier and localized_concepts
        expect(concept).to have_key("data")
        expect(concept["data"]).to have_key("identifier")
        expect(concept["data"]).to have_key("localized_concepts")
        expect(concept["data"]["localized_concepts"]).to be_a(Hash)
      end
    end

    it "creates localized_concept files with V2 structure" do
      localized_files = Dir.glob(File.join(glossarist_output_dir, "localized_concept", "*.yaml"))
      expect(localized_files).not_to be_empty

      localized_files.each do |file|
        localized = YAML.safe_load(File.read(file), permitted_classes: [Date, Time])

        # V2: localized concept must have id (UUID) at root level
        expect(localized).to have_key("id")
        expect(localized["id"]).to match(/^[0-9a-f-]{36}$/)

        # V2: localized concept must have data with language_code and terms
        expect(localized).to have_key("data")
        expect(localized["data"]).to have_key("language_code")
        expect(localized["data"]["language_code"]).to match(/^[a-z]{3}$/)
        expect(localized["data"]).to have_key("terms")
        expect(localized["data"]["terms"]).to be_an(Array)
      end
    end

    it "links concepts to localized concepts via UUID" do
      concept_files = Dir.glob(File.join(glossarist_output_dir, "concept", "*.yaml"))
      localized_files = Dir.glob(File.join(glossarist_output_dir, "localized_concept", "*.yaml"))

      localized_uuids = localized_files.map do |file|
        YAML.safe_load(File.read(file), permitted_classes: [Date, Time])["id"]
      end

      concept_files.each do |file|
        concept = YAML.safe_load(File.read(file), permitted_classes: [Date, Time])
        referenced_uuids = concept["data"]["localized_concepts"].values

        referenced_uuids.each do |uuid|
          expect(localized_uuids).to include(uuid)
        end
      end
    end
  end
end
