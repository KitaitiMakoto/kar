require "rake/tasklib"
require "rake/file_task"
require "uri"
require "net/https"
require "tmpdir"
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
        patch_open_uri

        mtime = File.mtime(t.name) if File.file? t.name
        Dir.mktmpdir do |dir|
          tempfile = File.join dir, File.basename(t.name)
          File.open(tempfile, "wb+") do |to|
            @uri.read to:, request_specific_fields: {"If-Modified-Since" => mtime&.httpdate}
          end
          move tempfile, t.name
        end
      end
    end

    def patch_open_uri
      require_relative "uri-http-download"
    end
  end
end
