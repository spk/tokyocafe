require 'tokyocafe/persistable/meta_classes'

module TokyoCafe
  module Persistable
    # this method will be added to the class as an instance method

    include TokyoCabinet
    attr_accessor :id, :created_at, :updated_at

    @@tdb = TDB::new

    def initialize(args={})
      args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
    end

    def new?
      self.id.nil?
    end

    def save(db_uri = location)
      perform_callback(:before_save)
      tokyo_open
      @location = db_uri
      if new?
        performed = tokyo_create
      else
        performed = tokyo_update
      end
      tokyo_close
      perform_callback(:after_save)
      performed
    end

    def delete
      performed = false
      unless new?
        perform_callback(:before_delete)
        tokyo_open
        performed = @@tdb.out(self.id)
        tokyo_close
        perform_callback(:after_delete)
      end
      performed
    end
    alias destroy delete

    def to_s
      self.id
    end

    def to_h
      parameters = {}
      parameters['class'] = self.class.to_s

      if RUBY_VERSION.to_f > 1.8
        excluded_instance_variables = [:@location, :@created_at,
                                       :@updated_at]
      else
        excluded_instance_variables = ['@location', '@created_at',
                                       '@updated_at']
      end
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
    def tokyo_open
      unless @@tdb.open(location, TDB::OWRITER | TDB::OCREAT)
        ecode = @@tdb.ecode
        STDERR.printf("open error: %s\n", @@tdb.errmsg(ecode))
      end
    end

    def tokyo_close
      @@tdb.close
    end

    def tokyo_create
      perform_callback(:before_create)

      hash_value = self.to_h

      pkey = @@tdb.genuid
      doc_hash = hash_value.merge({'id' => pkey})

      if @@tdb.put(pkey, doc_hash)
        @id = pkey
        if self.class::tokyo_cafe_timestamp_on_create?
          @created_at = Time.now.to_s
        end
        performed = true
      else
        ecode = @@tdb.ecode
        STDERR.printf("put error: %s\n", @@tdb.errmsg(ecode))
        performed = false
      end
      perform_callback(:after_create)
      performed
    end

    def tokyo_update
      perform_callback(:before_update)
      if self.class::tokyo_cafe_timestamp_on_update?
        @updated_at = Time.now.to_s
      end

      doc_value = self.to_h
      if @@tdb.put(id, doc_value)
        @id = id
        if self.class::tokyo_cafe_timestamp_on_create?
          @created_at = created_at
        end
        performed = true
      else
        ecode = @@tdb.ecode
        STDERR.printf("put error: %s\n", @@tdb.errmsg(ecode))
        performed = false
      end
      perform_callback(:after_update)
      performed
    end

    #
    # Performs callbacks before and after these events:
    # * create
    # * update
    # * save
    # * delete
    #
    def perform_callback(the_callback)
      self.send(the_callback) if self.respond_to?(the_callback)
    end

    module ClassMethods
      # this method will be added to the class as a class method
      include TokyoCabinet

      def get_by_id(id, db_uri = self.location)
        @@tdb = TDB::new
        unless @@tdb.open(db_uri, TDB::OREADER)
          ecode = @@tdb.ecode
          STDERR.printf("open error: %s\n", @@tdb.errmsg(ecode))
        end
        if id && @@tdb.get(id)
          h = @@tdb.get(id)
          res = self.new(h)
        else
          res = nil
        end
        @@tdb.close
        return res
      end
      alias get get_by_id

      # :conditions => {:name => 'tokyo'}, :limit => 3, :order => { :name => :ASC }
      def search(options = {}, db_uri = self.location)
        @@tdb = TDB::new
        unless @@tdb.open(db_uri, TDB::OREADER)
          ecode = @@tdb.ecode
          STDERR.printf("open error: %s\n", @@tdb.errmsg(ecode))
        end
        qry = TDBQRY::new(@@tdb)
        if options.include?(:conditions)
          options[:conditions].each do |k,v|
            qry.addcond(k.to_s, TDBQRY::QCSTREQ, v.to_s)
          end
        end
        if options.include?(:limit) && options[:limit].to_i > 0
          qry.setlimit(options[:limit])
        end
        if options.include?(:order)
          options[:order].each do |k,v|
            qry.setorder(k.to_s, TDBQRY.const_get("QOSTR#{v.to_s.upcase}"))
          end
        end
        res = qry.search
        @@tdb.close
        return res
      end

      def set_location=(db_uri)
        @location = db_uri == "" ? nil : db_uri
      end

    end
  end
end
