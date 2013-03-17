module GridFu
  class Table
    private
    def render_tag(context, options, *args, &block)
      options = options.slice(:tag, :html)
      options.each do |key, option|
        options[key] = option.is_a?(Proc) ?
          context.instance_exec(*args, &option) : option
      end
      tag(options[:tag], options[:html], &block)
    end

    # Renders html tag with given options and content. Context renders even
    # tag argument is null.
    #
    # Example:
    # tag('tbody', {class: 'test'}) do
    #   "The new tag!"
    # end
    def tag(tag, options, &block)
      html = []
      if tag.present?
        html << "<#{tag}"
         if options.present?
          html << ' '
          html << to_html_args(options)
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