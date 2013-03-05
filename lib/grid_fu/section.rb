module GridFu
  class Section < Element
    attr_reader :rows

    config_accessor :cell_tag

    def initialize(tag, cell_tag, *args, &block)
      self.rows  = []

      config.tag      = tag
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
end
