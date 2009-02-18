require 'tokyocafe/persistable/meta_classes'

module TokyoCafe
  module Persistable
    # this method will be added to the class as an instance method

    include TokyoCabinet
    attr_accessor :id, :created_at, :updated_at

    def initialize(args={})
      args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
    end

    def new?
      self.id.nil?
    end

    def save(db_uri = location)
      @location = db_uri
      if new?
        tokyo_create
      else
        tokyo_update
      end
    end

    def to_s
      self.id
    end

    def to_h
      parameters = {}
      parameters[:class] = self.class

      excluded_instance_variables = ['@location', '@created_at', '@updated_at']
      instance_variables = self.instance_variables - excluded_instance_variables
      instance_variables.each do |k|
        key = k[1..-1]
        value = self.instance_variable_get(k)
        parameters[key.to_sym] = value
      end

      if self.class::tokyo_cafe_timestamp_on_update?
        parameters[:updated_at] = Time.now
      end

      unless new?
        # update
        parameters[:id] = id
        if self.class::tokyo_cafe_timestamp_on_create?
          parameters[:created_at] = created_at
        end
      else
        # create
        if self.class::tokyo_cafe_timestamp_on_create?
          parameters[:created_at] = Time.now
        end
      end
      parameters
    end

    def to_json
      parameters = self.to_h
      begin
        parameters.to_json
      rescue JSON::GeneratorError
        TokyoCafe::Utils::decode_strings(parameters).to_json
      end
    end

    protected
    def tokyo_create
      hdb = HDB::new
      if !hdb.open(location, HDB::OWRITER | HDB::OCREAT)
        ecode = hdb.ecode
        STDERR.printf("open error: %s\n", hdb.errmsg(ecode))
      end
      hash_value = self.to_h

      require 'uuid'
      uuid = UUID.new.generate
      doc_hash = hash_value.merge({:id => uuid})
      json_value = doc_hash.to_json

      if hdb.put(uuid, json_value)
        @id = uuid
        if self.class::tokyo_cafe_timestamp_on_create?
          @created_at = Time.now
        end
        true
      else
        ecode = hdb.ecode
        STDERR.printf("put error: %s\n", hdb.errmsg(ecode))
        false
      end
    end

    def tokyo_update
      if self.class::tokyo_cafe_timestamp_on_update?
        @updated_at = Time.now
      end
      hdb = HDB::new
      if !hdb.open(location, HDB::OWRITER | HDB::OCREAT)
        ecode = hdb.ecode
        STDERR.printf("open error: %s\n", hdb.errmsg(ecode))
      end

      json_value = self.to_json
      if hdb.put(id, json_value)
        @id = id
        if self.class::tokyo_cafe_timestamp_on_create?
          @created_at = created_at
        end
        true
      else
        ecode = hdb.ecode
        STDERR.printf("put error: %s\n", hdb.errmsg(ecode))
        false
      end
    end

    module ClassMethods
      # this method will be added to the class as a class method
      include TokyoCabinet

      def get_by_id(id, db_uri = self.location)
        hdb = HDB::new
        unless hdb.open(db_uri, HDB::OREADER)
          ecode = hdb.ecode
          STDERR.printf("open error: %s\n", hdb.errmsg(ecode))
        end
        if id && hdb.get(id)
          h = JSON.parse(hdb.get(id))
          self.new(h)
        else
          nil
        end
      end
      alias get get_by_id

      def set_location=(db_uri)
        @location = db_uri == "" ? nil : db_uri
      end

    end
  end
end
