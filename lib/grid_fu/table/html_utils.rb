module GridFu
  class Table
    # Renders html tag with given options and content.
    # Yields options which are procs with given options.
    # Tagname is passed with :tag option.
    def tag(options, *args, &block)
      tag, html_options = get_options([:tag, :html], options, *args)

      html = []
      if tag.present?
        html << "<#{tag}"
         if html_options.present?
          html << ' '
          html << to_html_args(html_options)
        end
        html << '>'
      end
      html << yield if block_given?
      html << "</#{tag}>" if tag.present?
      html.join
    end

    # Translates hash to HTML attributes string. Accepts nested attributes.
    #
    # Example:
    #   to_html_args(ref: true, data: { id: 1 }) # ref="true" data-id="1"
    def to_html_args(options, prepend = nil)
      options = options || {}
      html_args = options.map do |key, value|
        if value.is_a?(Hash)
          to_html_args(value, key)
        else
          key = "#{prepend}-#{key}" if prepend.present?
          %{#{key}="#{value}"}
        end
      end
      html_args.join(' ')
    end
  end
end