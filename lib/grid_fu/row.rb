module GridFu
  class Row < Element
    attr_reader :cells

    config.tag = 'tr'

    def initialize(cell_tag, *args, &block)
      self.cells = []

      config.cell_tag = cell_tag

      super
    end

    protected
    def html_content(member, index)
      html = cells.map do |cell|
        cell.to_html(member, index)
      end
      html.join
    end

    def cell(*args, &block)
      self.cells << Cell.new(config.cell_tag, *args, &block)
    end

    attr_writer :cells
  end
end
