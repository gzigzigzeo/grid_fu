module GridFu
  class Table < Element
    attr_reader :header_content, :body_content, :footer_content

    def initialize(*args, &block)
      config.tag ||= 'table'

      super
    end

    protected
    def html_content(collection, resource_class = nil)
      body_content.to_html(collection, resource_class)
    end

    def body(*args, &block)
      self.body_content = Body.new(*args, &block)
    end

    attr_writer :header_content, :body_content, :footer_content
  end
end
