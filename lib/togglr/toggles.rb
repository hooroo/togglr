#encoding: utf-8

require 'togglr/base_toggle'
require 'togglr/yaml_reader'

module Togglr
  class Toggles
    include Singleton

    def self.register_toggles
      toggles_source.toggles.each do |name, value|
        register_toggle(name, value)
      end
    end

    def self.each(&block)
      instance.toggles.each(&block)
    end

    def toggles
      @toggles ||= []
    end

    private
      def self.register_toggle(name, properties)
        f = BaseToggle.new(name, properties[:value], repositories)
        instance.toggles << f
        define_singleton_method("#{name}?") do
          f.active?
        end

        define_singleton_method("#{name}=") do |new_value|
          f.active = new_value
        end
      end

      def self.toggles_source
        YamlReader.new(Togglr.configuration.toggles_file)
      end

      def self.repositories
        Togglr.configuration.repositories.map do |repo|
          get_class(repo).new
        end
      end

      def self.get_class(class_name)
        class_name.split('::').inject(Object) do |mod, name|
          mod.const_get(name)
        end
      end
  end
end
