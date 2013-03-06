module GridFu
  class Table < Element
    attr_reader :thead, :tbody, :tfoot

    config.tag = 'table'

    protected
    def html_content(collection, resource_class = nil)
      thead.to_html(collection, resource_class) +
      tbody.to_html(collection, resource_class) +
      tfoot.to_html(collection, resource_class)
    end

    def header(*args, &block)
      self.thead = Header.new('th', *args, &block)
    end

    def body(*args, &block)
      self.tbody = Body.new('td', *args, &block)
    end

    def footer(*args, &block)
      self.tfoot = Footer.new('td', *args, &block)
    end

    attr_writer :thead, :tbody, :tfoot
  end
end