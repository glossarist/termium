# frozen_string_literal: true

require_relative "../termium"

module Termium
  # Command-line interface
  class Cli < Thor
    desc "convert", "Convert TERMIUM entries into a Glossarist dataset"

    option :input_file, aliases: :i, required: true, desc: "Path to TERMIUM Plus XML extract"
    option :output_file, aliases: :o, desc: "Output file path"
    option :date_accepted, desc: "Date of acceptance for the dataset"

    no_commands do
      def input_file_as_path(input_file)
        input_path = Pathname.new(Dir.pwd).join(Pathname.new(input_file))

        unless input_path.exist?
          error "TERMIUM export file `#{options[:input_file]}` does not exist."
          exit 1
        end

        input_path
      end

      def output_dir_as_path(output_path, input_path)
        output_path ||= input_path.dirname.join(input_path.basename(input_path.extname))

        output_path = Pathname.new(Dir.pwd).join(output_path)
        create_or_use_output_path(output_path)
        output_path
      end

      def create_or_use_output_path(output_path)
        output_path_rel = output_path.relative_path_from(Dir.pwd)
        if output_path.exist?
          puts "Using existing directory: #{output_path_rel}"
        else # and is directory
          puts "Created directory: #{output_path_rel}"
          output_path.mkdir
        end
      end
    end

    def convert
      input_path = input_file_as_path(options[:input_file])

      puts "Reading TERMIUM export file: #{input_path.relative_path_from(Dir.pwd)}"
      termium_extract = Termium::Extract.from_xml(IO.read(input_path.expand_path))

      puts "Size of TERMIUM dataset: #{termium_extract.core.size}"

      puts "Converting to Glossarist..."
      convert_options = {}
      if options[:date_accepted]
        convert_options[:date_accepted] = Date.parse(options[:date_accepted])
      end
      glossarist_col = termium_extract.to_concept(convert_options)
      # pp glossarist_col.first

      output_path = output_dir_as_path(options[:output_file], input_path)
      puts "Writing Glossarist dataset to: #{output_path.relative_path_from(Dir.pwd)}"
      glossarist_col.save_to_files(output_path.expand_path)
      puts "Done."
      exit 0
    end

    def method_missing(*args)
      warn "No method found named: #{args[0]}"
      warn "Run with `--help` or `-h` to see available options"
      exit 1
    end

    def respond_to_missing?
      true
    end

    def self.exit_on_failure?
      true
    end
  end
end
