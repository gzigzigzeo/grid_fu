module GridFu
  class Element
    protected
    # Catches a call to configuration option setter.
    #
    # Example:
    # body do
    #   html_options { class: 'test' } # Holds such calls
    # end
    def method_missing(method_name, *args, &block)
      return super unless method_name.to_s.in?(config.allowed_configuration_options)
      config[method_name] = args.first || block

      class_eval do
        define_method method_name do |value|
          config[method_name] = value
        end
        protected method_name
      end

      config[method_name]
    end

    config.allowed_configuration_options = %w(
      tag html_options override_html_options
    )
    config.html_options                  = {}
    config.override_html_options         = {}
    config.render_nested_elements        = []
    config.tag                           = nil
  end
end