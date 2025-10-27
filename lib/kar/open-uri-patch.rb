require "open-uri"

OpenURI::Options[:to] = nil

Module.new do
  def <<(data)
    data.force_encoding(io.charset) if io&.charset
    super
  end

  OpenURI::Buffer.prepend self
end

Module.new do
  def buffer_open(buf, proxy, options)
    if options[:to]
      buf.instance_variable_set(:@io, options[:to])
    end
    super
  end

  [URI::HTTP, URI::FTP].each do |klass|
    klass.prepend self
  end
end
