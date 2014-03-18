module GlobalConfiguration
  class Configuration < ActiveRecord::Base
    self.primary_key = :key

    validates :key, presence: true

    def data
      data_string || data_integer || data_float || data_boolean
    end

    def data=(value)
      self.data_integer = (value if value.is_a?(Integer))
      self.data_float = (value if value.is_a?(Float))
      self.data_boolean = (value if (value.is_a?(TrueClass) || value.is_a?(FalseClass)))
      self.data_string = (value if value.is_a?(String))
    end

    def self.write(key, value)
      key = key.to_s

      if !key.blank?
        if value.present?
          configuration = find_or_initialize_by(key: key)
          configuration.data = value
          if configuration.save
            Rails.cache.write(cache_key(key), value)
            true
          end
        else
          delete(key)
        end
      end
    end

    def self.write!(key, value)
      write(key, value) or raise(ArgumentError, 'key must not be blank')
    end

    def self.read(key)
      key = key.to_s

      if !key.blank?
        Rails.cache.fetch(cache_key(key)) do
          find(key).data rescue nil 
        end
      end
    end

    def self.delete(key)
      result = find(key.to_s).try(:destroy) rescue false
      if result
        Rails.cache.delete(cache_key(key))
      end
      result
    end

    def self.delete!(key)
      delete(key) or raise(ArgumentError, 'key must not be blank')
    end

    def self.[](key)
      read(key)
    end

    def self.[]=(key, value)
      write!(key, value)
    end

    private

    def self.cache_key(key)
      { configurations: key.to_s }
    end

  end
end