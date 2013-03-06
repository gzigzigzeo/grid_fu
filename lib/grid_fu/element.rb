module GridFu
  class Element
    include ActiveSupport::Configurable

    config.html_options = {}
    config.tag          = proc {
      raise NotImplementedError, "Set a tag for #{self.class.name}"
    }

    def initialize(*args, &definition)
      instance_exec(&definition) if block_given?
      set_options([:tag, :html_options], *args)
    end
  end
end
