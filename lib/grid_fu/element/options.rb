module GridFu
  class Element
    protected
    def set_options(expected, *args)
      options = args.extract_options!

      expected.each do |name|
        config[name] = options.delete(name) if options.key?(name)
      end
    end

    def get_options(expected, *args)
      expected.map do |name|
        config[name].is_a?(Proc) ? config[name].call(*args) : config[name]
      end
    end

    def self.option_setter(name)
      define_method name do |value = nil, &block|
        if value.present? || block.present?
          config[name] = value || block
        end
      end
    end

    option_setter :tag
    option_setter :html_options
  end
end