require 'tokyocafe/persistable/meta_classes'

module TokyoCafe
  module Persistable
    # this method will be added to the class as an instance method

    include TokyoCabinet
    attr_accessor :id, :created_at, :updated_at, :tdb

    def initialize(args={})
      @tdb = TDB::new
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
      parameters['class'] = self.class.to_s

      excluded_instance_variables = [:@location, :@created_at, :@updated_at, :@tdb]
      instance_variables = self.instance_variables - excluded_instance_variables
      instance_variables.each do |k|
        key = k[1..-1]
        value = self.instance_variable_get(k)
        parameters[key] = value
      end

      if self.class::tokyo_cafe_timestamp_on_update?
        parameters['updated_at'] = Time.now.to_s
      end

      unless new?
        # update
        parameters['id'] = id
        if self.class::tokyo_cafe_timestamp_on_create?
          parameters['created_at'] = created_at
        end
      else
        # create
        if self.class::tokyo_cafe_timestamp_on_create?
          parameters['created_at'] = Time.now.to_s
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
      if !@tdb.open(location, TDB::OWRITER | TDB::OCREAT)
        ecode = @tdb.ecode
        STDERR.printf("open error: %s\n", @tdb.errmsg(ecode))
      end
      hash_value = self.to_h

      uid = @tdb.genuid
      doc_hash = hash_value.merge({'id' => uid})

      if @tdb.put(uid, doc_hash)
        @id = uid
        if self.class::tokyo_cafe_timestamp_on_create?
          @created_at = Time.now.to_s
        end
        true
      else
        ecode = @tdb.ecode
        STDERR.printf("put error: %s\n", @tdb.errmsg(ecode))
        false
      end
    end

    def tokyo_update
      if self.class::tokyo_cafe_timestamp_on_update?
        @updated_at = Time.now.to_s
      end
      if !@tdb.open(location, TDB::OWRITER | TDB::OCREAT)
        ecode = @tdb.ecode
        STDERR.printf("open error: %s\n", @tdb.errmsg(ecode))
      end

      doc_value = self.to_h
      if @tdb.put(id, doc_value)
        @id = id
        if self.class::tokyo_cafe_timestamp_on_create?
          @created_at = created_at
        end
        true
      else
        ecode = @tdb.ecode
        STDERR.printf("put error: %s\n", @tdb.errmsg(ecode))
        false
      end
    end

    module ClassMethods
      # this method will be added to the class as a class method
      include TokyoCabinet

      def get_by_id(id, db_uri = self.location)
        @tdb = TDB::new
        unless @tdb.open(db_uri, TDB::OREADER)
          ecode = @tdb.ecode
          STDERR.printf("open error: %s\n", @tdb.errmsg(ecode))
        end
        if id && @tdb.get(id)
          h = @tdb.get(id)
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
