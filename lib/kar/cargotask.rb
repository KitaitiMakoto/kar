require "rake/clean"
require "rubygems/ext"
require "json"
require "shellwords"
require "stringio"

module Kar
  class CargoTask < Rake::TaskLib
    def initialize(target)
      @target = target

      define
    end

    private

    def verbose?
      Rake.verbose == true
    end

    def define
      file dl_path => [manifest, lock_file] + src do |t|
        results = Results.new
        begin
          Gem::Ext::CargoBuilder.new.build t.source, ".", results, [], lib_dir, File.expand_path(ext_dir)
        rescue => error
          $stderr.puts results unless verbose?
          fail
        end
      end
      CLEAN.include dl_name, dl_path

      namespace :cargo do
        task @target => dl_path

        # TODO: Consider the case `target` is "validate"
        namespace :validate do
          task @target => manifest do |t|
            `cargo metadata --format-version=1 --manifest-path=#{manifest.shellescape} --locked --quiet`
            fail unless $?.success?
          end
        end

        desc "Validate Cargo.lock files"
        task validate: "cargo:validate:#{@target}"
      end

      desc "Build all extensions in Rust"
      task cargo: "cargo:#{@target}"
    end

    def gemspec
      @gemspec ||= Gem::Specification.load("#{@target}.gemspec")
    end

    def manifest
      @manifest ||= gemspec.extensions.first
    end

    def lock_file
      @lock_file ||= manifest.ext(".lock")
    end

    def ext_dir
      @ext_dir ||= File.dirname(manifest)
    end

    def lib_dir
      # When a gem include an extension, the first element of require_paths is the directory for extensions and the second is for Ruby files.
      @lib_dir ||= gemspec.require_paths[1]
    end

    def dl_name
      @dl_name ||= "#{gemspec.name}.#{RbConfig::CONFIG["DLEXT"]}"
    end

    def dl_path
      @dl_path ||= File.join(lib_dir, dl_name)
    end

    def src
      @src ||= FileList["#{ext_dir}/src/**/*.rs"]
    end

    class Results
      def initialize
        @io = verbose? ? $stdout : StringIO.new
      end

      def <<(output)
        # Always break a line even when output isn't terminated by a line break
        @io.puts output
      end

      def to_s
        if verbose?
          ""
        else
          @io.rewind
          @io.read
        end
      end

      private

      def verbose?
        Rake.verbose == true
      end
    end
  end
end
