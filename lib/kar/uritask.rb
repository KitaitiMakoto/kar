require "rake/tasklib"
require "rake/file_task"
require "uri"
require "net/https"
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

        mtime = File.mtime(t.name) if File.file? t.name
        @uri.open request_specific_fields: {"If-Modified-Since" => mtime&.httpdate} do |input|
          tempfile = Tempfile.open {|output|
            while chunk = input.read(1024)
              output.write chunk
            end
            output
          }
          move tempfile, t.name
        end
      end
    end
  end
end
