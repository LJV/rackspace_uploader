require 'fog'
require 'fileutils'

module LJV

  class RackspaceUploader

    MAX_SEGMENT_SIZE = 1024 * 1024 * 5000 # 5 Gigabytes
    BUFFER_SIZE = 1024 * 1024 # 1 Megabyte
    
    def initialize(config)
      @username = config[:username] || (raise StandardError, "You must specify a Rackspace username")
      @api_key = config[:api_key] || (raise StandardError, "You must specify a Rackspace API key")
      @snet = config[:snet] || false
    end

    def upload(filepath, container_name, object_name)
      if File.size(filepath) > MAX_SEGMENT_SIZE
        upload_file_with_segments(filepath, container_name, object_name)
      else
        upload_file_without_segments(filepath, container_name, object_name)
      end
    end

    private

      def upload_file_with_segments(filepath, container_name, object_name)
        File.open(filepath) do |file|
          segment = 0
          begin
            offset = 0
            segment += 1
            service.put_object(container_name, "#{object_name}/#{segment}", nil) do
              if offset + BUFFER_SIZE <= MAX_SEGMENT_SIZE
                buf = file.read(BUFFER_SIZE).to_s
                offset += buf.size
                buf
              else
                ''
              end
            end
          end until file.eof?
          service.put_object_manifest(container_name, object_name, 'X-Object-Manifest' => "#{container_name}/#{object_name}/")
        end
      end

      def upload_file_without_segments(filepath, container_name, object_name)
        File.open(filepath, "r") do |file|
          service.put_object(container_name, object_name, nil) do
            file.read(BUFFER_SIZE).to_s
          end
        end
      end

      def service
        @service ||= Fog::Storage.new({
            :provider            => 'Rackspace',         # Rackspace Fog provider
            :rackspace_username  => @username, # Your Rackspace Username
            :rackspace_api_key   => @api_key,       # Your Rackspace API key
            :rackspace_region    => :ord,                # Defaults to :dfw
            :connection_options  => {}                   # Optional
        })
      end

  end

end


