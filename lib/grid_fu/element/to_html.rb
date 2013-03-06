module GridFu
  class Element
    def to_html(*args)
      tag, html_options = get_options([:tag, :html_options], *args)

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
      raise NotImplementedError, "Must implement #html_content for #{self.class.name}"
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
  end
end