require "rake/tasklib"
require "rake/file_task"
require "uri"
require "net/https"
require "tempfile"
require "time"

module Kar
  # Instanctiated in {DSL#download}
  class URITask < Rake::TaskLib
    module Util
      module_function

      # @todo Consider return value type
      #
      # @param uri [URI] URI to fetch content
      # @param to [String] File path to save content
      # @param headers [Hash<String, Object?>] HTTP headers
      # @return [String] File path content saved, same to +to+
      # @return [nil] if remote file responded with 304 Not Modified
      def fetch_http(uri, to, headers = {})
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == "https"
        http.start do |http|
          File.open to, "wb" do |file|
            http.request_get uri, headers do |response|
              return if response.kind_of? Net::HTTPNotModified

              response.read_body do |chunk|
                file.write chunk
              end
              begin
                File.utime Time.now, Time.httpdate(response["Last-Modified"]), to
              rescue => err
                warn err
              end
            end
          end
        end
        to
      end
    end

    include Util

    def initialize(file_and_uri)
      @to = file_and_uri.keys.first
      @uri = URI(file_and_uri.values.first)
      define
    end

    private

    def define
      unless %w[http https].include? @uri.scheme
        raise ArgumentError, "Unsupported URI scheme: #{@uri}"
      end

      file @to do |t|
        mtime = File.mtime(t.name) if File.file? t.name
        tempfile = Tempfile.new
        tempfile.close
        case @uri.scheme
        when "http", "https"
          result = fetch_http(@uri, tempfile, {"If-Modified-Since" => mtime&.httpdate})
          if result
            move tempfile, t.name
          else
            File.unlink tempfile
            Rake::Task[@to].tap do |task|
              def task.needed?
                false
              end
            end
          end
        else
          raise ArgumentError, "Unsupported URI scheme: #{@uri}"
        end
      end
    end
  end
end
