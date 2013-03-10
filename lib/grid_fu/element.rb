module GridFu
  class Element
    include ActiveSupport::Configurable

    def initialize(*args, &definition)
      instance_exec(&definition) if block_given?
      options = args.extract_options!
      config.merge!(options)
    end
  end
end