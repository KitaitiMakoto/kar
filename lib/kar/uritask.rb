require "rake/tasklib"
require "uri"
require "tempfile"
require "time"

module Kar
  # Instanctiated in {DSL#download}
  class URITask < Rake::TaskLib
    def initialize(file_and_uri)
      @to = file_and_uri.keys.first
      @uri = URI(file_and_uri.values.first)
      define
    end

    private

    def define
      unless %w[http https ftp].include? @uri.scheme
        raise ArgumentError, "Unsupported URI scheme: #{@uri}"
      end

      file @to do |t|
        require "open-uri"

        @uri.open do |input|
          tempfile =
            if input.respond_to?(:to_path)
              input.close
              input
            else
              Tempfile.open {|output|
                output.write input.read
                output
              }
            end
          move tempfile.to_path, t.name
        end
      end
    end
  end
end
