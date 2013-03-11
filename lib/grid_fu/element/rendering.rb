module GridFu
  class Element
    # Translates element to html tag.
    def to_html(*args)
      tag, override_html_options, html_options =
        get_options([:tag, :override_html, :html], *args)

      raise "Set tag option for #{self.class.name}" if tag.blank?

      html_options = override_html_options.merge(html_options)
      html_options = _to_html_args(html_options)

      html = []

      html << "<#{tag}"
      html << " #{html_options}" if html_options.present?
      html << '>'

      html << html_content(*args).to_s

      html << "</#{tag}>"
      html.join
    end

    def element_to_html(element, *args)
      send(element).map { |item| item.to_html(*args) }.join
    end

    protected
    # HTML content for element. Renders elements set by :render_nested_elements
    # wrapped by :tag.
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
    # Translates html to HTML attributes string. Accepts nested
    # data-attributes.
    #
    # Example:
    #   _to_html_args(ref: true, data: { id: 1 }) # ref="true" data-id="1"
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

    # Gets given option values. If an option is a block - yields it and
    # returns value.
    def get_options(keys, *args)
      keys = Array.wrap(keys)
      keys.map do |name|
        config[name].is_a?(Proc) ? config[name].call(*args) : config[name]
      end
    end
  end
end
