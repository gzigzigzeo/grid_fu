module GridFu
  class Table < Element
    attr_reader :thead, :tbody, :tfoot

    def initialize(*args, &block)
      config.tag ||= 'table'

      super
    end

    protected
    def html_content(collection, resource_class = nil)
      thead.to_html(collection, resource_class) +
      tbody.to_html(collection, resource_class) +
      tfoot.to_html(collection, resource_class)
    end

    def header(*args, &block)
      self.thead = Section.new('thead', 'th', *args, &block)
    end

    def body(*args, &block)
      self.tbody = Body.new('tbody', 'td', *args, &block)
    end

    def footer(*args, &block)
      self.tfoot = Section.new('tfoot', 'td', *args, &block)
    end

    attr_writer :thead, :tbody, :tfoot
  end
end