module GridFu
  class Element
    def to_html(*args)
      tag, html_options = get_options([:tag, :html_options], *args)

      raise "Set tag option for #{self.class.name}" if tag.blank?

      html_options = _to_html_args(html_options)

      html = []

      html << "<#{tag}"
      html << " #{html_options}" if html_options.present?
      html << '>'

      html << html_content(*args).to_s

      html << "</#{tag}>"
      html.join
    end

    protected
    def html_content(*args)
      nested = get_options(:render_nested_elements, *args).first

      if nested.blank?
        raise "Set render_nested_elements options or override #html_content/#to_html for #{self.class.name}"
      end

      html = nested.map do |element|
        self.send(element).map { |element| element.to_html(*args) }.join
      end
      html.join
    end

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

    def get_options(keys, *args)
      keys = Array.wrap(keys)
      keys.map do |name|
        config[name].is_a?(Proc) ? config[name].call(*args) : config[name]
      end
    end
  end
end