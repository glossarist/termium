# frozen_string_literal: true

require "open3"
require "tmpdir"
require "yaml"

RSpec.describe Termium do
  let(:extract) do
    Termium::Extract.from_xml(File.read(fixtures_path("Characters.xml")))
  end

  # The TERMIUM entry used throughout: identificationNumber 2123225, which has
  # both an EN and a FR languageModule.
  let(:identification_number) { "2123225" }
  let(:core) do
    extract.core.find { |c| c.identification_number == identification_number }
  end

  def save_to_tmp(options = {})
    Dir.mktmpdir do |dir|
      extract.to_concept(options).save_to_files(dir)
      yield(
        Dir.glob("#{dir}/concept/*.yaml").map { |f| YAML.load_file(f) },
        Dir.glob("#{dir}/localized_concept/*.yaml").map { |f| YAML.load_file(f) }
      )
    end
  end

  describe "#to_concept" do
    it "carries the TERMIUM identification number as the concept identifier" do
      doc = core.to_concept.to_yaml_hash

      expect(doc.dig("data", "identifier")).to eq(identification_number)
    end

    it "registers one localization per language, keyed by language code" do
      expect(core.to_concept.localizations.keys).to contain_exactly("eng", "fre")
    end

    it "cross-references every localization from the concept" do
      doc = core.to_concept.to_yaml_hash

      expect(doc.dig("data", "localized_concepts").keys)
        .to contain_exactly("eng", "fre")
    end

    it "gives each localization a distinct uuid" do
      map = core.to_concept.to_yaml_hash.dig("data", "localized_concepts")

      expect(map["eng"]).not_to eq(map["fre"])
    end

    it "populates the localized concept from the TERMIUM entry" do
      data = core.to_concept.localization("eng").to_yaml_hash["data"]

      aggregate_failures do
        expect(data["language_code"]).to eq("eng")
        expect(data["terms"].map { |t| t["designation"] })
          .to include("average information rate")
        expect(data.dig("definition", 0, "content"))
          .to start_with("quotient of the character mean entropy")
      end
    end

    it "wraps notes as detailed definitions" do
      data = core.to_concept.localization("eng").to_yaml_hash["data"]

      expect(data["notes"].map { |n| n["content"] })
        .to include(a_string_including("average information rate may be expressed"))
    end
  end

  describe "#to_concept with date_accepted" do
    let(:date_accepted) { "2024-01-15" }

    it "records the accepted date on the concept" do
      save_to_tmp(date_accepted: date_accepted) do |concepts, _localized|
        expect(concepts)
          .to all(include("date_accepted" => a_string_starting_with(date_accepted)))
      end
    end

    it "records the accepted date on every localized concept" do
      save_to_tmp(date_accepted: date_accepted) do |_concepts, localized|
        expect(localized)
          .to all(include("date_accepted" => a_string_starting_with(date_accepted)))
      end
    end
  end

  # glossarist's save_to_files calls FileUtils without requiring it, so requiring
  # "termium" must be sufficient on its own. This has to run in a clean subprocess:
  # in-process the spec's own `require "tmpdir"` loads fileutils and masks the bug,
  # which is why it reaches production while the suite stays green.
  describe "loading termium standalone" do
    # Passes argv directly rather than through a shell: POSIX quoting would
    # reach cmd.exe verbatim on Windows and mangle the script.
    def save_in_clean_process(dir)
      root = File.expand_path("..", __dir__)
      script = <<~RUBY
        require "termium"
        xml = File.read(#{File.join(root, 'spec/fixtures/Characters.xml').inspect})
        Termium::Extract.from_xml(xml).to_concept.save_to_files(#{dir.inspect})
      RUBY
      Open3.capture2e(RbConfig.ruby, "-I#{File.join(root, 'lib')}", "-e", script,
                      chdir: root)
    end

    it "can save a dataset without the caller requiring fileutils" do
      output, status = Dir.mktmpdir { |dir| save_in_clean_process(dir) }

      aggregate_failures do
        expect(output).not_to include("NameError")
        expect(status).to be_success
      end
    end
  end

  describe "#save_to_files" do
    it "writes one concept per entry and one localized concept per language" do
      save_to_tmp do |concepts, localized|
        aggregate_failures do
          expect(concepts.size).to eq(extract.core.size)
          expect(localized.size)
            .to eq(extract.core.sum { |c| c.language_module.size })
        end
      end
    end
  end
end
