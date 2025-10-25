require "kar/uritask"
require "kar/cargotask"

module Kar
  # DSLs you can use in your Rakefiles
  #
  # @example
  #   # Rakefile
  #   require "kar/dsl"
  #
  #   SRC = FileList["src/**/*.md"]
  #
  #   # Defines file tasks for SRC
  #   files SRC
  #   file "book.epub" => SRC do |t|
  #     htmls = compile_markdowns(t.sources)
  #     package_epub(t.name, htmls)
  #   end
  #
  #   # Downloads file from https://example.com/remote/file and save to local/file
  #   download "local/file" => "https://example.org/remote/file"
  #
  #   # Build extension in Rust
  #   cargo "my_gem"
  module DSL
    def files(file_list)
      file_list.each do |file_name|
        file file_name
      end
    end

    # def file(*args, &block)
    #   if args.first.kind_of? Hash
    
    #   end
    # end

    # @example
    #   # Rakefile
    #   download "local/file" => "https://example.org/remote/file"
    #   download "another/local/file" => URI("https://example.org/another/remote/file")
    # @example Include the tasks into dependency tree
    #   # Rakefile
    #   file "file.txt" => "local/file.txt.gz" do |t|
    #     sh "gunzip #{t.source}"
    #   end
    #   download "local/file.txt.gz" => "https://example.org/remote/file.txt.gz"
    # @raise [ArgumentError] if URI scheme is unsupported
    def download(args)
      URITask.new args
    end

    # Declare a cargo task which builds extension in Rust by Cargo.
    #
    # @example
    #   # Rakefile
    #   cargo "my_gem"
    #
    #   task build: :cargo
    #
    #   # shell
    #   % rake cargo
    #
    # Also defines a cargo:validate task which validates version `Cargo.lock`s are up-to-date.
    # It's useful to add them to the dependency of build task and prevent building invalid gem package.
    #
    # Uses {https://docs.ruby-lang.org/en/master/Gem/Ext/CargoBuilder.html Gem::Ext::CargoBuilder} internally unlike {https://oxidize-rb.org/docs/api-reference/rb-sys-gem-config#rbsysextensiontask RbSys::ExtensionTask}
    # in order to build in the same way as `gem install` command, even though the output might be less usefull.
    # When `RbSys::Extension` uses the same way, this function may be deprecated.
    def cargo(target)
      CargoTask.new target
    end

    Rake::DSL.prepend self
  end
end
