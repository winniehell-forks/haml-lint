module HamlLint
  # Stores configuration for haml-lint.
  class Configuration
    # Creates a configuration from the given options hash.
    #
    # @param options [Hash]
    def initialize(options)
      @hash = options
      validate
    end

    # Compares this configuration with another.
    #
    # @param other [HamlLint::Configuration]
    # @return [true,false] whether the given configuration is equivalent
    def ==(other)
      super || @hash == other.hash
    end
    alias_method :eql?, :==

    # Returns a non-modifiable configuration for the specified linter.
    #
    # @param linter [HamlLint::Linter]
    def for_linter(linter)
      smarge_merge(@hash['linters']['ALL'],
                   @hash['linters'][linter.name]).freeze
    end

    # Merges the given configuration with this one, returning a new
    # {Configuration}. The provided configuration will either add to or replace
    # any options defined in this configuration.
    #
    # @param config [HamlLint::Configuration]
    def merge(config)
      self.class.new(smart_merge(@hash, config.hash))
    end

  protected

    attr_reader :hash

  private

    # Returns whether the specified linter is enabled by this configuration.
    #
    # @param linter [HamlLint::Linter]
    def linter_enabled?(linter)
      for_linter(linter)['enabled'] != false
    end

    # Validates the configuration for any invalid options, normalizing it where
    # possible.
    def validate
      @hash = convert_nils_to_empty_hashes(@hash)
      ensure_linter_section_exists(@hash)
    end

    def smart_merge(parent, child)
      parent.merge(child) do |key, old, new|
        case old
        when Array
          old + Array(new)
        when Hash
          smart_merge(old, new)
        else
          new
        end
      end
    end

    def ensure_linter_section_exists(hash)
      hash['linters'] ||= {}
      hash['linters']['ALL'] ||= {}
    end

    def convert_nils_to_empty_hashes(hash)
      hash.inject({}) do |h, (key, value)|
        h[key] =
          case value
          when nil  then {}
          when Hash then convert_nils_to_empty_hashes(value)
          else
            value
          end
        h
      end
    end
  end
end
