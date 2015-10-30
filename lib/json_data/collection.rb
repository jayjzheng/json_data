require 'json'

module JSONData
  module Collection
    module ClassMethods
      def data_class(klass, options = {})
        formatter = options.fetch(:formatter) { lambda {|json| json} }

        define_method :data_source= do |json|
          raw = json.is_a?(Array) ? json : JSON.parse(json)
          @data_source = formatter.call(raw).map {|data| klass.new(data_source: data) }
        end
      end
    end

    def self.included(base)
      base.send :include, Enumerable
      base.send :extend, ClassMethods
    end

    def initialize(options = {})
      self.data_source = options.fetch(:data_source) { [] }
    end

    def each(&block)
      data_source.each { |d| block.call(d) }
    end

    def valid?
      !empty? && all? { |d| d.valid? }
    end

    def empty?
      data_source.empty?
    end

    private

    attr_reader :data_source
  end
end
