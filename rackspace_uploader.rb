module LJV

  class RackspaceUploader

    def initialize(config)
      @username = config[:username] || raise StandardError, "You must specify a Rackspace username"
      @apikey = config[:apikey] || raise StandardError, "You must specify a Rackspace API key"
      @snet = config[:snet] || false
    end

    def upload(filepath, container_name, object_name)
      container = connection.container(container_name)
      object = container.create_object(object_name)
      object.load_from_filename(backup_filepath)
      puts "Uploaded #{filepath} to rackspace"
    end

    private

      def connection
        @connection ||= CloudFiles::Connection.new(:username => @username, :api_key => @api_key, :snet => @snet) 
      end

  end

end


