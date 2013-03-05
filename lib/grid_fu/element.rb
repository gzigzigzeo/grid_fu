module GridFu
  class Element
    include ActiveSupport::Configurable

    def initialize(*args, &block)
      instance_exec(&block) if block_given?

      config.html_options ||= {}

      set_options([:tag, :html_options], *args)
    end

    def to_html(*args, &block)
      tag, html_options = get_options([:tag, :html_options], *args)

      html_options = _to_html_args(html_options)

      html = []
      html << "<#{tag}"
      if html_options.present?
        html << " #{html_options}"
      end
      html << '>'

      if block_given?
        html << yield(*args)
      else
        html << html_content(*args).to_s
      end

      html << "</#{tag}>"

      html.join
    end

    protected
    def html_content(*args)
      raise NotImplementedError, "Must implement #html_content for #{self.class.name} or pass a block for #to_html"
    end

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

    private
    def _to_html_args(options, prepend = nil)
      options = options || {}
      html_args = options.map do |key, value|
        if value.is_a?(Hash)
          _to_html_args(value, key)
        else
          key = "#{prepend}-#{key}" if prepend.present?
          %{#{key}="#{value}"}
        end
      end
      html_args.join(' ')
    end
  end
end
