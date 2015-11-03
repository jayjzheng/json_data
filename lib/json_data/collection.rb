module JSONData
  module Collection
    module ClassMethods
      def data_class(klass, options = {})
        formatter = options.fetch(:formatter) { ->(json) { json } }

        define_method :create_data_objects do
          @data_source = formatter.call(data_source).map do |data|
            klass.new(data_source: data)
          end
        end
      end
    end

    def self.included(base)
      base.send :include, Enumerable
      base.send :extend, ClassMethods
    end

    def initialize(options = {})
      @handler = options.fetch(:handler) { Handler.new }
      self.data_source = options.fetch(:data_source) { [] }
    end

    def data_source=(json)
      @data_source = handler.parse(json)
      create_data_objects
    end

    def each(&block)
      data_source.each { |d| block.call(d) }
    end

    def valid?
      !empty? && all?(&:valid?)
    end

    def empty?
      data_source.empty?
    end

    private

    attr_reader :data_source, :handler

    def create_data_objects
    end
  end
end
