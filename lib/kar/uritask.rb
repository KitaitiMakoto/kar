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
      REDIRECT_LIMIT = 3

      module_function

      # @todo Consider return value type
      #
      # @param uri [URI] URI to fetch content
      # @param to [String] File path to save content
      # @param headers [Hash<String, Object?>] HTTP headers
      # @return [String] File path content saved, same to +to+
      # @return [nil] if remote file responded with 304 Not Modified
      def fetch_http(uri, to, headers = {}, redirected = 0)
        if redirected > REDIRECT_LIMIT
          raise "Too many HTTP redirects"
        end
        Net::HTTP.start uri.host, uri.port, use_ssl: uri.scheme == "https" do |http|
          request = Net::HTTP::Get.new(uri, headers)
          http.request request do |response|
            case response
            when Net::HTTPNotModified
              # noop
            when Net::HTTPOK
              File.open to, "wb" do |file|
                response.read_body do |chunk|
                  file.write chunk
                end
                now = Time.now
                last_modified = response["last-modified"]
                mtime = last_modified ? Time.httpdate(last_modified) : now
                File.utime now, Time.httpdate(response["Last-Modified"]), to
              end
            when Net::HTTPRedirection
              fetch_http URI(response["location"]), to, headers, redirected + 1
            else
              raise "#{response.code} #{response.message}\n#{response.body}"
            end
          end
        end

        to
      end

      private

      def fetch_http_with_redirection_handling(uri, headers = {})
        Net::HTTP.start uri.host, uri.port, use_ssl: uri.scheme == "https" do |http|
          request = Net::HTTP::Get.new(uri, headers)
          http.request request do |response|
            case response
            when Net::HTTPRedirection
              return fetch_http_with_redirection_handling(URI(response["location"]), headers)
            when Net::HTTPOK
              return response
            else
              raise "#{response.code} #{response.message}\n#{response.body}"
            end
          end
        end
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
