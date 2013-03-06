module GridFu
  class Section < Element
    attr_reader :rows

    option_setter :cell_tag

    def initialize(cell_tag, *args, &block)
      self.rows  = []

      config.cell_tag = cell_tag

      super
    end

    protected
    def html_content(*args)
      rows.map { |row| row.to_html(*args) }.join(' ')
    end

    def row(*args, &block)
      self.rows << Row.new(config.cell_tag, &block)
    end

    attr_writer :rows
  end

  class Header < Section
    config.tag = 'thead'
    config.cell_tag = 'th'
  end

  class Footer < Section
    config.tag = 'tfoot'
    config.cell_tag = 'td'
  end
end
