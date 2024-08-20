require "kar/uritask"

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

    Rake::DSL.prepend self
  end
end
