module TokyoCafe
  module Persistable
    def self.included(klass)
      klass.extend(TokyoCafe::Persistable::ClassMethods)

      klass.class_eval do

        ##
        # Timestamps
        ##

        # Timestamps are false by default
        def self.tokyo_cafe_timestamp_on_update?; false; end
        def self.tokyo_cafe_timestamp_on_create?; false; end

        #
        # Adds timestamps to the class.
        #
        # Example:
        #
        #   class Vacation
        #     include TokyoCafe::Persistable
        #     add_timestamp_for :on_create, :on_update
        #   end
        #
        #   my_vacation = Vacation.new
        #   my_vacation.save(db_address)
        #   my_vacation.created_at => Somedate
        #   my_vacation.updated_at => Somedate
        #
        def self.add_timestamp_for(*timestamp_actions)
          timestamp_actions.each do |action|
            case action
            when :on_create
              self.class_eval do
                def self.tokyo_cafe_timestamp_on_create?; true; end
              end
            when :on_update
              self.class_eval do
                def self.tokyo_cafe_timestamp_on_update?; true; end
              end
            end
          end
        end

        # Location methods are added both as instance methods and
        # as class level methods. The class level methods are needed
        # when loading new objects from the database and the instance
        # methods are used throughout the class
        def self.location; @tokyo_cafe_class_storage_location ||= nil; end
        def location; @location; end
        alias storage_location location

        #
        # Sets the location of the database to use by default
        #
        # Example:
        #
        #   class AppleTree
        #     include TokyoCafe::Persistable
        #     database 'db/db.hdb'
        #   end
        #
        #   apple_tree = AppleTree.new
        #   apple_tree.save # saves automatically to the predefined
        #                   # database location
        #
        def self.database(db_uri)
          @tokyo_cafe_class_storage_location = db_uri
          self.instance_eval do
            define_method("location") do
              @location ||= db_uri
            end
          end
        end

      end
    end
  end
end
