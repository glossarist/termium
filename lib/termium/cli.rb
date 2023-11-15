# frozen_string_literal: true

require_relative "../termium"

module Termium
  # Command-line interface
  class Cli < Thor
    desc "convert", "Convert Termium entries into a Glossarist dataset"

    option :input_file, aliases: :i, required: true, desc: "Path to TERMIUM Plus XML extract"
    option :output_file, aliases: :o, desc: "Output file path"

    def input_file_as_path
      input_path = Pathname.new(Dir.pwd).join(Pathname.new(options[:input_file]))

      unless input_path.exist?
        error "Input file `#{options[:input_file]}` does not exist."
        exit 1
      end

      input_path
    end

    def output_path_ready
      output_path = options[:output_file]
      output_path ||= input_path.dirname.join(input_path.basename(input_path.extname))

      output_path = Pathname.new(Dir.pwd).join(Pathname.new(output_path))

      if output_path.exist?
        puts "Using existing directory: #{output_path.relative_path_from(Dir.pwd)}"
      else # and is directory
        puts "Created directory: #{output_path.relative_path_from(Dir.pwd)}"
        output_path.mkdir
      end

      output_path
    end

    def convert
      input_path = input_file_as_path
      puts "Reading input file: #{input_path.relative_path_from(Dir.pwd)}"
      termium_extract = Termium::Extract.from_xml(IO.read(input_path.expand_path))

      puts "Size of dataset: #{termium_extract.core.size}"

      puts "Converting to Glossarist..."
      glossarist_col = termium_extract.to_concept
      # pp glossarist_col.first

      output_path = output_path_ready
      puts "Writing Glossarist dataset..."
      glossarist_col.save_to_files(output_path.expand_path)
      puts "Written Glossarist dataset to: #{output_path.relative_path_from(Dir.pwd)}"
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
